class LLNode<T> {

    T _cargo;    //cargo may only be of type T
    LLNode<T> _nextNode; //pointer to next LLNode


    // constructor -- initializes instance vars
    LLNode( T value, LLNode<T> next ) {
        _cargo = value;
        _nextNode = next;
    }


    //--------------v  ACCESSORS  v--------------
    T getValue() { return _cargo; }

    LLNode<T> getNext() { return _nextNode; }
    //--------------^  ACCESSORS  ^--------------


    //--------------v  MUTATORS  v--------------
    T setValue( T newCargo ) {
	      T foo = getValue();
        _cargo = newCargo;
        return foo;
    }

    LLNode<T> setNext( LLNode<T> newNext ) {
        LLNode<T> foo = getNext();
        _nextNode = newNext;
        return foo;
    }
    //--------------^  MUTATORS  ^--------------

}//end class LLNode
