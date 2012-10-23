In the readers/writers lab there are two processes, the reader and writer.  The writer writes the pangram: A quick brown fox jumps over the lazy dog to an array of strings named book.  
The writer will overwrite the book array in a ring buffer like fashion.  The reader reads the contents of book and prints it to the Nios II console.
  
Access to the shared data structure book is synchronized by the semaphore, shared_buf_sem.

Additional functionality:
-Add two more readers
-Allow multiple reads to book at once
