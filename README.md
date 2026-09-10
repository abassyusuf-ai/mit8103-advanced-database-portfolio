# MIT 8103 Advanced Database Systems Portfolio

This repository contains a practical database systems portfolio developed for the MIT 8103 Advanced Database Systems continuous assessment.

## Portfolio Activities

1. Database Design and Modelling
2. Query Processing and Optimisation
3. Transactions and Concurrency
4. NoSQL and Advanced Data Models
5. Distributed and Cloud Database Exercise

## Case Study

The portfolio implements a multi-branch retail order and inventory management system. PostgreSQL is used for transactional data, while MongoDB is used for the flexible product catalogue.

## Technologies

- PostgreSQL 16
- MongoDB 7
- Docker Desktop
- Docker Compose
- SQL
- MongoDB Query Language
- Git and GitHub

## Repository Structure

- `portfolio-1-database-design`: relational schema, ER diagram, sample data and validation
- `portfolio-2-query-optimisation`: queries, indexes, execution plans and performance results
- `portfolio-3-transactions-concurrency`: transactions, locking and concurrency tests
- `portfolio-4-nosql`: MongoDB documents, validation, indexing and queries
- `portfolio-5-distributed-cloud`: replication, access control, backup and recovery evidence

## Running the Databases

Create a local `.env` file using `.env.example`, then run:

```bash
docker compose up -d