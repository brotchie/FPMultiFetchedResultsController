FPMultiFetchedResultsController
===============================

FPMultiFetchedResultsController is a NSFetchedResultsController that supports multiple NSFetchRequest and correctly handles section and row mutations when transitioning between underlying fetch requests.

A FPMultiFetchedResultsController extends the NSFetchedResultsController interface. On inititialization a FPMultiFetchedResultsController accepts a dictionary of NSFetchRequest objects. Each NSFetchRequest is uniquely named by its key in this dictionary.
