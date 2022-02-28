import 'package:get/get.dart';
import 'package:note_app_teachers/model/student.dart';

class CDController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Student> student = Student("", "", "").obs;
  setIsLoading(bool val) {
    isLoading.value = val;
  }

  setStudent(Student val) {
    student.value = val;
  }
}
