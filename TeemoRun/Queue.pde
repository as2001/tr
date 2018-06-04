class Queue<T> {
    
    LLNode<T> _head, _tail;
    int _size;
    
    Queue() {
        _size = 0;
    }
    
    //means of removing an element from collection:
    //Dequeues and returns the first element of the queue.
    T dequeue() {
        if ( isEmpty() ) return null;
        T q = _head.getValue();
        _head = _head.getNext();
        if ( _size == 1 ) _tail = null;
        _size --;
        return q;
    }

    //means of adding an element to collection:
    //Enqueue an element onto the back of this queue.
    void enqueue( T x ) {
        if ( isEmpty() ) {
            _head = new LLNode(x, null);
            _tail = _head;
        } else {
            _tail.setNext( new LLNode(x, null) );
            _tail = _tail.getNext();
        }
        _size ++;
    }

    //Returns true if this queue is empty, otherwise returns false.
    boolean isEmpty() {
        return _size == 0;
    }

    //Returns the first element of the queue without dequeuing it.
    T peekFront() {
        return _head.getValue();
    }

}
