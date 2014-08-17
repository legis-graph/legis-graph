#!/usr/bin/env bash

neo4j-shell < load_legislators.cql
neo4j-shell < load_bills.cql
neo4j-shell < load_subjects.cql
neo4j-shell < load_congresses.cql
neo4j-shell < load_bills_congresses.cql
neo4j-shell < load_bills_subjects.cql
neo4j-shell < load_bills_legislators.cql
neo4j-shell < load_votes.cql
