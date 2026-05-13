use std::{
    sync::{Condvar, Mutex},
    time::Instant,
};

type TokenAcquirer = dyn Fn() -> Result<(String, Instant), String> + Sync + Send;

enum TokenManagerState {
    Empty,
    Pending,
    Valid(String, Instant),
}

struct TokenManager {
    acquire_token: Mutex<Box<TokenAcquirer>>,
    state: Mutex<TokenManagerState>,
    cv: Condvar,
}

impl TokenManager {
    pub fn new(acquire_token: Box<TokenAcquirer>) -> Self {
        TokenManager {
            acquire_token: Mutex::new(acquire_token),
            state: Mutex::new(TokenManagerState::Empty),
            cv: Condvar::new(),
        }
    }

    fn set_pending_and_acquire(
        &self,
        mut state: std::sync::MutexGuard<'_, TokenManagerState>,
    ) -> Result<String, String> {
        *state = TokenManagerState::Pending;
        drop(state);
        let res = (self.acquire_token.lock().unwrap())();
        let mut state = self.state.lock().unwrap();
        match res {
            Ok((token, expiry)) => {
                *state = TokenManagerState::Valid(token.clone(), expiry);
                self.cv.notify_all();
                Ok(token)
            }
            Err(e) => {
                *state = TokenManagerState::Empty;
                self.cv.notify_all();
                Err(e)
            }
        }
    }

    pub fn get_token(&self) -> Result<String, String> {
        let mut state = self.state.lock().unwrap();
        while let TokenManagerState::Pending = &*state {
            state = self.cv.wait(state).unwrap();
        }

        match &*state {
            TokenManagerState::Valid(token, expiry) if Instant::now() < *expiry => {
                Ok(token.clone())
            }
            _ => self.set_pending_and_acquire(state),
        }
    }

    pub fn try_get_token(&self) -> Option<String> {
        let state = self.state.lock().unwrap();
        if let TokenManagerState::Valid(token, expiry) = &*state
            && Instant::now() < *expiry
        {
            Some(token.clone())
        } else {
            None
        }
    }
}

fn main() {
    // Example usage
    let acquirer = Box::new(|| {
        Ok((
            "example_token".to_string(),
            Instant::now() + std::time::Duration::from_secs(300),
        ))
    });
    let manager = TokenManager::new(acquirer);

    match manager.get_token() {
        Ok(token) => println!("Acquired token: {}", token),
        Err(e) => println!("Failed to acquire token: {}", e),
    }

    // Try to get token without blocking
    if let Some(token) = manager.try_get_token() {
        println!("Token is available: {}", token);
    } else {
        println!("No valid token available.");
    }
}

#[test]
fn a_new_manager_contains_no_token() {
    let a: Box<TokenAcquirer> = Box::new(|| Err("failure".to_string()));
    let manager = TokenManager::new(a);
    assert!(manager.try_get_token().is_none());
}
#[test]
fn a_failing_acquirer_always_returns_an_error() {
    let a: Box<TokenAcquirer> = Box::new(|| Err("failure".to_string()));
    let manager = TokenManager::new(a);
    assert_eq!(manager.get_token(), Err("failure".to_string()));
    assert_eq!(manager.get_token(), Err("failure".to_string()));
}
#[test]
fn a_successful_acquirer_always_returns_success() {
    let a: Box<TokenAcquirer> = Box::new(|| {
        Ok((
            "token".to_string(),
            Instant::now() + std::time::Duration::from_secs(60),
        ))
    });
    let manager = TokenManager::new(a);
    assert_eq!(manager.get_token(), Ok("token".to_string()));
    assert_eq!(manager.get_token(), Ok("token".to_string()));
}
#[test]
fn a_slow_acquirer_causes_other_threads_to_wait() {
    use std::thread;
    use std::time::Duration;

    let a: Box<TokenAcquirer> = Box::new(|| {
        thread::sleep(Duration::from_millis(100));
        Ok((
            "token".to_string(),
            Instant::now() + std::time::Duration::from_secs(60),
        ))
    });
    let manager = std::sync::Arc::new(TokenManager::new(a));

    let handles: Vec<_> = (0..5)
        .map(|_| {
            let mgr = std::sync::Arc::clone(&manager);
            thread::spawn(move || mgr.get_token())
        })
        .collect();

    for handle in handles {
        assert_eq!(handle.join().unwrap(), Ok("token".to_string()));
    }
}
