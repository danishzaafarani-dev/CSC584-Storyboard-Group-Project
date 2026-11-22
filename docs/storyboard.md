# Updated Storyboard — Campus Bazaar

**Project title:** Campus Bazaar: Pre-Loved Textbook & Gear Exchange

| Scene | Screen / module | User action | System response |
|---|---|---|---|
| 1 | Register / Login | Student registers using student details or logs in. | System validates credentials and account status. Student accounts may require verification before listing or transacting. |
| 2 | Homepage | Student browses featured listings and categories. | System displays available items. |
| 3 | Marketplace Search | Student searches by keyword and filters by category, condition or price. | System displays matching available listings. |
| 4 | Item Details | Student views item description, condition, price, photos and seller details. | System displays the listing and allows the student to save it, message the seller or submit a request. |
| 5 | Wishlist | Student saves or removes an item. | System creates or deletes the USER–ITEM wishlist association. |
| 6 | Create Listing | Seller enters item details, category, condition, price, quantity and multiple photos. | System saves the ITEM and its ITEM_IMAGE records. |
| 7 | Messaging | Buyer and seller exchange messages, optionally linked to a transaction. | System stores messages and creates notifications for recipients. |
| 8 | Purchase / Exchange Request | Buyer selects purchase or exchange and, for exchange, selects an item they own to offer. | System validates the request and creates a PENDING transaction. |
| 9 | Manage Request | Seller accepts or rejects a pending request. | System updates transaction status and notifies the buyer. An accepted request reserves the requested item. |
| 10 | Meet and Confirm | Buyer and seller agree on a campus meeting location and each confirms completion. | System records completion only after the required confirmations. Item status changes to SOLD or EXCHANGED. |
| 11 | Review | Transaction participants rate and comment on the other participant. | System stores reviews only for completed transactions, subject to one review per person per transaction. |
| 12 | Report / Moderation | Student reports an item or user; authorized moderator reviews it. | System records the report and updates its moderation status. |
| 13 | Notifications | Student views unread alerts. | System displays transaction, message, review and report updates. |

## Updated system scope

### Student functions
- Register and log in using student details.
- Browse, search and filter item listings.
- View item details and multiple item photos.
- Create, edit and deactivate own listings.
- Save and remove wishlist items.
- Send and receive messages.
- Submit purchase and exchange requests.
- Accept, reject, cancel and confirm transactions according to permissions.
- Receive notifications.
- Review the other participant after a completed transaction.
- Report an item or user.

### Moderator / administrator functions
- Review submitted reports.
- Resolve or dismiss reports.
- Suspend accounts or deactivate inappropriate listings, subject to authorization.
- Manage categories.

## Business rules
1. A student cannot request their own listing.
2. For an exchange, the offered item must belong to the requesting student and be available.
3. A listing should not have more than one active accepted transaction at a time.
4. Only the seller of the requested item can accept or reject the request.
5. A transaction is completed only after both participants confirm the handover.
6. A completed transaction updates the requested item to SOLD or EXCHANGED. The offered item in an exchange must also be updated consistently.
7. Only participants in a completed transaction can submit a review, and each participant can review only once per transaction.
8. A report targets either a user or an item.
9. Users can edit or deactivate only their own listings; moderators have separate permissions.
10. Passwords must be stored as secure hashes, never as plaintext.

## Prototype and implementation note
The supplied HTML/CSS remains a front-end demonstration. The added database design describes proposed functionality; it does not mean login, messaging, wishlist, notifications, moderation or transaction processing are already operational. These functions require backend routes, authentication, authorization, validation and database integration. The SQL file creates the database structure but does not implement every cross-table business rule; see `docs/business-rules.md`.
