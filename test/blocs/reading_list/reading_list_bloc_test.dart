// Test for every event and yielding the expected state

// Adding a book
// Book goes to right list position based on type
// If book exists, the old book is updated
// If book exists, notes are appended, recos are added (if not duplicate), updated at timestamp is set

// Updating a book (ref update components of add book)

// Deleting a book - removes it from the list, based on id

// Reordering a book will change the index location in ReadingList
// Reordering a book will change the type if moved to a different type sublist

// Test _getTypeByIndex and _getTypeChangeIndex in ListRepo

// Test the Stats Cubit computation of list counts

// Reading List Tests
// If the reading list is 1 book of "TO_READ" renders 2 tiles (Read & To Read) followed by ListTile for test book
// If BOTH "READING" and "TO_READ" == 0, then render helper image
// Run test on _updateType w/ output based on input type

// User Screen
// If "READ" == 0, then render helper image
// If enableHeaders == false, don't render ListedBookHeader
// The list only generates tiles for includedTypes array values

void main() {}
