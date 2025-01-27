-- Drop and create movies table
IF OBJECT_ID('dbo.movies', 'U') IS NOT NULL
    DROP TABLE dbo.movies;

CREATE TABLE dbo.movies
(
    movie_id INT PRIMARY KEY,
    title NVARCHAR(255),
    genre NVARCHAR(255),
    runtime INT,
    year_of_release INT,
    renting_price DECIMAL(10, 2)
);

-- Drop and create actors table
IF OBJECT_ID('dbo.actors', 'U') IS NOT NULL
    DROP TABLE dbo.actors;

CREATE TABLE dbo.actors
(
    actor_id INT PRIMARY KEY,
    name NVARCHAR(255),
    year_of_birth INT,
    nationality NVARCHAR(255),
    gender NVARCHAR(50)
);

-- Drop and create actsin table
IF OBJECT_ID('dbo.actsin', 'U') IS NOT NULL
    DROP TABLE dbo.actsin;

CREATE TABLE dbo.actsin
(
    actsin_id INT PRIMARY KEY,
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id) REFERENCES dbo.movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES dbo.actors(actor_id)
);

-- Drop and create customers table
IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL
    DROP TABLE dbo.customers;

CREATE TABLE dbo.customers
(
    customer_id INT PRIMARY KEY,
    name NVARCHAR(255),
    country NVARCHAR(255),
    gender NVARCHAR(50),
    date_of_birth DATE,
    date_account_start DATE
);

-- Drop and create renting table
IF OBJECT_ID('dbo.renting', 'U') IS NOT NULL
    DROP TABLE dbo.renting;

CREATE TABLE dbo.renting
(
    renting_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating INT,
    date_renting DATE,
    FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id),
    FOREIGN KEY (movie_id) REFERENCES dbo.movies(movie_id)
);






