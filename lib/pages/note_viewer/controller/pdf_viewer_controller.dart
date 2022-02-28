// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PVController extends GetxController {
  RxBool isDownloading = false.obs;
  Rx<int> allPageCount = 0.obs;
  RxString filePath = "".obs;
  Rx<PdfControllerPinch> pdfController = PdfControllerPinch(
          initialPage: 1, document: PdfDocument.openAsset("assets/pdf.pdf"))
      .obs;
  setIsDownloading(bool val) {
    isDownloading.value = val;
  }

  setAllPageCount(int val) {
    allPageCount.value = val;
  }

  setFilePath(String val) {
    filePath.value = val;
  }

  setController(PdfControllerPinch val) {
    pdfController.value = val;
  }
}
