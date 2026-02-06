# PixelAstral Database Schema

## Table of Contents
- [Database Schema](#database-schema)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Core Entities](#core-entities)
  - [Entity Relationships](#entity-relationships)
  - [SQL Schema](#sql-schema)
    - [Create Tables](#create-tables)
  - [Sample Data](#sample-data)
    - [Database Type] Sample Data
  - [Data Types Notes](#data-types-notes)
  - [Migration Notes](#migration-notes)

## Overview

This document describes complete database schema for PixelAstral, including all entities, relationships, and sample data.

## Core Entities

> **Note**: Update this section when database structure is defined.

### Entity 1
| Column             | Type     | Nullable | Description                                                |
| ------------------ | -------- | -------- | ---------------------------------------------------------- |
| id                 | int/uuid | No       | Primary key, auto-incremented/unique ID                    |
| [other columns]  | types    | Yes/No   | Descriptions                                               |

### Entity 2
| Column             | Type     | Nullable | Description                                                |
| ------------------ | -------- | -------- | ---------------------------------------------------------- |
| [columns...]       | types    | Yes/No   | Descriptions                                               |

## Entity Relationships

```
entity1 (1) ──── (many) entity2
entity1 (1) ──── (1) entity3
```

## SQL Schema

### Create Tables

> **Note**: Update this section with actual database schema when database is implemented.

For [Database Type], use following adapted schema:

```sql
-- Entity 1 table
CREATE TABLE entity1 (
    id SERIAL PRIMARY KEY,
    uuid TEXT NOT NULL UNIQUE,
    -- other columns
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Entity 2 table
CREATE TABLE entity2 (
    id TEXT PRIMARY KEY,
    entity1_uuid TEXT,
    -- other columns
    FOREIGN KEY (entity1_uuid) REFERENCES entity1(uuid)
);
```

## Sample Data

### [Database Type] Sample Data

```sql
-- Insert sample data
INSERT INTO entity1 (uuid, name, created_at)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'Sample Name', CURRENT_TIMESTAMP);
```

## Data Types Notes

- **UUID**: Stored as TEXT for simplicity
- **Arrays**: Stored as native database arrays
- **JSON**: Stored as JSONB for performance
- **Boolean**: Stored as BOOLEAN
- **Datetime**: Stored as TIMESTAMP with CURRENT_TIMESTAMP defaults

## Migration Notes

When deploying to production:

1. Review all SQL changes
2. Backup existing data
3. Add proper constraints and indexes
4. Test migrations in staging first
