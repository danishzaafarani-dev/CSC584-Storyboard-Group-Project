# Campus Bazaar — Pre-Loved Textbook & Gear Exchange

A responsive HTML/CSS front-end prototype and an expanded MySQL database design for a student-to-student campus marketplace.

## Project contents

- `index.html` — homepage
- `login.html` — login / registration prototype
- `marketplace.html` — marketplace and search prototype
- `item.html` — item details prototype
- `sell.html` — create listing prototype
- `requests.html` — transaction request prototype
- `storyboard.html` — clickable storyboard
- `css/` — page and shared styling
- `database/schema.sql` — updated MySQL 8.0.16+ schema (10 entities)
- `docs/ERD.md` — updated Mermaid ERD and relationship explanation
- `docs/storyboard.md` — expanded user journey and system scope
- `docs/business-rules.md` — validation and transaction rules

## Updated database entities

1. USER
2. CATEGORY
3. ITEM
4. ITEM_IMAGE
5. TRANSACTION
6. WISHLIST
7. MESSAGE
8. REVIEW
9. NOTIFICATION
10. REPORT

The seller for a transaction is derived from `ITEM.seller_id`, so the seller ID is not duplicated in TRANSACTION. PAYMENT and DELIVERY are not included because the current scope focuses on campus meetups rather than integrated payment or delivery services. Administrator access is treated as a permission/role concern, not a separate entity in this version.

## Run the front-end prototype

1. Extract the ZIP file.
2. Open `index.html` in a browser, or open the folder in VS Code and use Live Server.
3. The HTML pages are a visual prototype. The new functions described in the updated storyboard are proposed features and are not yet connected to a backend.

## Create the database

1. Use MySQL 8.0.16 or later.
2. Run `database/schema.sql` in MySQL Workbench or another MySQL client.
3. The script creates the `campus_bazaar` database, all 10 tables, indexes, constraints and starter categories.
4. Connect a backend application before expecting registration, listings, messages, transactions or other features to work.

**Important:** The SQL schema does not implement every cross-table rule. Refer to `docs/business-rules.md` for required backend validation, transaction handling and authorization. Never store plaintext passwords. Use secure password hashing and verify student accounts in the backend.

## View / export the ERD

Open `docs/ERD.md` in GitHub to render the Mermaid diagram, or copy the Mermaid code into [Mermaid Live Editor](https://mermaid.live/) to export PNG or SVG.

## Suggested submission contents

For a database/system design submission, include:
- Updated ERD (`docs/ERD.md`)
- SQL schema (`database/schema.sql`)
- System storyboard (`docs/storyboard.md`)
- Business rules (`docs/business-rules.md`)
- Front-end prototype pages and styles

## GitHub submission

Create a repository named `campus-bazaar`, upload the extracted project while preserving its folder structure, and submit the repository URL.
