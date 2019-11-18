buildInitials({String name}) {
    List splittedName = name.split(' ');
    String firstLetter = splittedName[0][0];
    String secondLetter =
        splittedName.length > 1 ? splittedName[1][0] : splittedName[0][1];
    String initials = ("$firstLetter$secondLetter").toUpperCase();
    return initials;
  }