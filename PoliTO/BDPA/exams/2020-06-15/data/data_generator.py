import csv
from faker import Faker
import random
from datetime import datetime, timedelta
from multiprocessing import Pool

fake = Faker()


# Generate Books.csv
def generate_books(args):
    filename, num_books = args
    with open(filename, "w", newline="", buffering=8192) as file:
        fieldnames = ["BID", "Title", "Genre", "Publisher", "YearOfPublication"]
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        for bid in range(1, num_books + 1):
            title = fake.text(max_nb_chars=50)
            genre = random.choice(
                [
                    "Adventure",
                    "Romance",
                    "Mystery",
                    "Crime",
                    "Science Fiction",
                    "Fantasy",
                ]
            )
            publisher = fake.company()
            year_of_publication = random.randint(1900, 2022)
            writer.writerow(
                {
                    "BID": f"BID{bid}",
                    "Title": title,
                    "Genre": genre,
                    "Publisher": publisher,
                    "YearOfPublication": year_of_publication,
                }
            )


# Generate Purchases.csv
def generate_purchases(args):
    filename, num_purchases = args
    with open(filename, "w", newline="", buffering=8192) as file:
        fieldnames = ["CustomerID", "BID", "Date", "Price"]
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        for _ in range(num_purchases):
            customer_id = f"customer{random.randint(1, 1000000)}"
            bid = f"BID{random.randint(1, 200000)}"
            purchase_date = fake.date_time_between(
                start_date="-15y", end_date="now"
            ).strftime("%Y%m%d")
            price = round(
                random.uniform(5.0, 50.0), 2
            )  # Random price between 5.0 and 50.0
            writer.writerow(
                {
                    "CustomerID": customer_id,
                    "BID": bid,
                    "Date": purchase_date,
                    "Price": price,
                }
            )


if __name__ == "__main__":
    num_books = 500000
    num_purchases = 1000000

    books_filename = "Books.csv"
    purchases_filename = "Purchases.csv"

    pool = Pool(processes=8)  # Number of processes

    pool.map(generate_books, [(books_filename, num_books)])
    pool.map(generate_purchases, [(purchases_filename, num_purchases)])

    pool.close()
    pool.join()
