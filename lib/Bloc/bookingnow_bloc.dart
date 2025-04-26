import 'package:doanngon/View/page/TicketScreen.dart';
import 'package:doanngon/View/page/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';



// Sự kiện
abstract class BookingEvent {}

class AddPersonEvent extends BookingEvent {}

class RemovePersonEvent extends BookingEvent {}

class SubmitBookingEvent extends BookingEvent {
  final BuildContext context;
  SubmitBookingEvent(this.context);
}

class NavigateToTicketScreenEvent extends BookingEvent {
  final BuildContext context;
  NavigateToTicketScreenEvent(this.context);
}

// Trạng thái
class BookingState {
  final List<Map<String, TextEditingController>> listPerson;
  final List<List<Map<String, String>>> bookings;
  final bool isSubmit;
  final String? error;

  BookingState({
    required this.listPerson,
    required this.bookings,
    required this.isSubmit,
    this.error,
  });
}

// Bloc
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc()
      : super(BookingState(
          listPerson: [
            {"name": TextEditingController(), "phone": TextEditingController()}
          ],
          bookings: [],
          isSubmit: false,
          error: null,
        )) {
    on<AddPersonEvent>((event, emit) {
      final newList = List<Map<String, TextEditingController>>.from(state.listPerson);
      newList.add({"name": TextEditingController(), "phone": TextEditingController()});
      emit(BookingState(listPerson: newList, bookings: state.bookings, isSubmit: false));
    });

    on<RemovePersonEvent>((event, emit) {
      if (state.listPerson.length > 1) {
        final newList = List<Map<String, TextEditingController>>.from(state.listPerson);
        final removedPerson = newList.removeLast();
        removedPerson["name"]?.dispose();
        removedPerson["phone"]?.dispose();
        emit(BookingState(listPerson: newList, bookings: state.bookings, isSubmit: false));
      }
    });

    on<SubmitBookingEvent>((event, emit) async {
      bool allFilled = true;
      String? newError;
      
      for (var person in state.listPerson) {
        if (person["name"]!.text.trim().isEmpty || person["phone"]!.text.trim().isEmpty) {
          allFilled = false;
          newError = "Vui lòng nhập đầy đủ thông tin";
          break;
        }
      }
      
      if (allFilled) {
        final newBooking = state.listPerson
            .map((p) => {
                  "name": p["name"]!.text.trim(),
                  "phone": p["phone"]!.text.trim(),
                  "tourName": "Tên tour mẫu" // Replace with actual tour name
                })
            .toList();
        final newBookings = List<List<Map<String, String>>>.from(state.bookings)..add(newBooking);
        // gửi email
        try{
          final smtpServer = gmail('vantu156123@gmail.com','tech bldq yfkf wdem');
          final message = Message()
            ..from = Address('vantu156123@gmail.com','bookingtour')
    
            ..recipients.addAll(['vantu156123@gmail.com','nhokdragon4a@gmail.com'])
            ..subject = 'thông tin đặt tour'
            ..text = 'Thông tin đặt tour:\n${newBooking.map((p) => "Tên: ${p["name"]}, SĐT: ${p["phone"]}").join("\n")}';
             await send(message, smtpServer);
        }catch(e){
          print("gui email that bai: $e");
        }
        emit(BookingState(listPerson: [{"name": TextEditingController(), "phone": TextEditingController()}], bookings: newBookings, isSubmit: true));

        // Show success message and navigate back to FullAppPage with updated bookings
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text("Đặt tour thành công!")),
        );
        Navigator.pushAndRemoveUntil(
          event.context,
          MaterialPageRoute(
            builder: (context) => FullAppPage(bookings: newBookings),
          ),
          (route) => false,
        );
      } else {
        emit(BookingState(listPerson: state.listPerson, bookings: state.bookings, isSubmit: false, error: newError));
      }
    });

    on<NavigateToTicketScreenEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => TicketScreen(bookings: state.bookings),
        ),
      );
    });
  }
}