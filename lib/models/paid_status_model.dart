class PaidStatus {
  final int id;
  double remainingAmount;
  double amountConverted;

  PaidStatus({
    this.remainingAmount = 0.0,
    this.amountConverted = 0.0,
    required this.id,
  });
  factory PaidStatus.fromJson(Map<String,dynamic> parsedJson){
    return PaidStatus(
      remainingAmount: double.parse(parsedJson['remaining_amount'].toString()),
      amountConverted: double.parse(parsedJson['amount_converted'].toString()),
      id: int.parse(parsedJson['id'].toString())
    );
  }
  Map<String,dynamic> toJson()=>{
    'remaining_amount' : remainingAmount,
    'amount_converted' : amountConverted,
    'id' : id,
  };
}
