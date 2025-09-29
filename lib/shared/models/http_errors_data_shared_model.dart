class HttpErrorsDataSharedModel {
  final String guideNumber;
  final String palletId;
  final String palletDestination;
  final String guideDestination;
  HttpErrorsDataSharedModel(
      {this.guideNumber = '', this.palletId = '', this.palletDestination = '', this.guideDestination = ''});

  factory HttpErrorsDataSharedModel.fromMap(Map<String, dynamic> map) {
    return HttpErrorsDataSharedModel(
        guideNumber: map['guideNumber'] ?? '',
        palletId: map['palletId'] ?? '',
        palletDestination: map['palletDestination'] ?? '',
        guideDestination: map['guideDestination'] ?? '');
  }
}
