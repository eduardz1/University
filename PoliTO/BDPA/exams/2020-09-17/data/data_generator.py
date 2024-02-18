import csv
from faker import Faker
import random
from datetime import datetime, timedelta
from multiprocessing import Pool

fake = Faker()


# Generate Users.csv
def generate_users(args):
    filename, num_users = args
    usernames = []
    with open(filename, "w", newline="", buffering=8192) as file:
        writer = csv.writer(file)
        for _ in range(num_users):
            username = fake.user_name() + str(random.randint(50, 99))
            gender = random.choice(["Male", "Female"])
            year_of_birth = random.randint(1950, 2002)
            country = fake.country()
            row = [username, gender, year_of_birth, country]
            writer.writerow(row)
            usernames.append(username)
    return usernames


# Generate Movies.csv
def generate_movies(args):
    filename, num_movies = args
    movie_ids = []
    with open(filename, "w", newline="", buffering=8192) as file:
        writer = csv.writer(file)
        for mid in range(1, num_movies + 1):
            title = fake.text(max_nb_chars=20)
            director = fake.name()
            release_date = fake.date_time_between(
                start_date="-30y", end_date="now"
            ).strftime("%Y/%m/%d")
            row = [f"MID{mid}", title, director, release_date]
            writer.writerow(row)
            movie_ids.append(mid)
    return movie_ids


# Generate WatchedMovies.csv
def generate_watched_movies(args):
    filename, usernames, movie_ids, num_watched = args
    with open(filename, "w", newline="", buffering=8192) as file:
        writer = csv.writer(file)
        for _ in range(num_watched):
            username = random.choice(usernames)
            mid = random.choice(movie_ids)
            start_timestamp = fake.date_time_between(start_date="-10y", end_date="now")
            movie_length = random.randint(60, 180)
            end_timestamp = start_timestamp + timedelta(minutes=movie_length)
            end_timestamp = min(end_timestamp, datetime.now())
            start_timestamp = start_timestamp.strftime("%Y/%m/%d_%H:%M")
            end_timestamp = end_timestamp.strftime("%Y/%m/%d_%H:%M")
            row = [username, f"MID{mid}", start_timestamp, end_timestamp]
            writer.writerow(row)


if __name__ == "__main__":
    num_users = 2000000
    num_movies = 200000
    num_watched = 1000000000

    users_filename = "Users.csv"
    movies_filename = "Movies.csv"
    watched_movies_filename = "WatchedMovies.csv"

    pool = Pool(processes=8)  # Number of processes

    pool.map(generate_users, [(users_filename, num_users)])
    pool.map(generate_movies, [(movies_filename, num_movies)])

    usernames = generate_users((users_filename, num_users))
    movie_ids = generate_movies((movies_filename, num_movies))

    pool.map(
        generate_watched_movies,
        [(watched_movies_filename, usernames, movie_ids, num_watched)],
    )

    pool.close()
    pool.join()
