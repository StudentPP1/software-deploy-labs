create table if not exists items (
    id bigint auto_increment primary key,
    name varchar(255) not null,
    quantity int not null,
    created_at timestamp not null
);