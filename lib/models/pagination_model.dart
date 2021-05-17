class PaginationModel {
  int dataToShow;
  int currentPage;
  int? lastPage;
  int? totalDataCount;
  String? nextPageUrl;
  String? prevPageUrl;
  String firstPageUrl;
  String currentPageUrl;
  String? lastPageUrl;

  PaginationModel({
    this.currentPage = 1,
    this.dataToShow = 10,
    this.lastPage,
    this.totalDataCount,
    this.nextPageUrl,
    this.prevPageUrl,
    this.firstPageUrl = "10?page=1",
    this.currentPageUrl = "10?page=1"
  });
}
