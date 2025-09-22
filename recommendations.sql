create table if not exists recommendations(
    recommendation_date DATE,
    stockName VARCHAR(50) not null,
    action VARCHAR(50) ,
    price_at_time_of_transaction float not null,
    source varchar(50) not null,
    target_price float
);