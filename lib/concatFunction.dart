class DisplayFunctions{

  String concatToDisplay(List<String>items, int numberToShow){
    String formattedJobType = items.join(" • ");

    List<String> jobTypeValues = formattedJobType.split(" • ");

    if (jobTypeValues.length > numberToShow) {
      formattedJobType = jobTypeValues.take(numberToShow).join(" • ");
      int remainingCount = jobTypeValues.length - numberToShow;
      formattedJobType += " ...+$remainingCount more";
    }
    return formattedJobType;
  }
}