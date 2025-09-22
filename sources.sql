create table if not exists sources(
    source_name varchar(200),
    confidence_rating float,
    total_turnover float,
    trades varchar(200),
    transaction_ids varchar(200)
);