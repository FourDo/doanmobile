import 'package:doanngon/Bloc/bookingnow_bloc.dart';
import 'package:doanngon/View/page/TicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingNowPage extends StatefulWidget {
  const BookingNowPage({super.key});

  @override
  State<BookingNowPage> createState() => _BookingNowPageState();
}

class _BookingNowPageState extends State<BookingNowPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Đặt Tour",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.listPerson.length,
                      itemBuilder: (context, index) {
                        final person = state.listPerson[index];
                        return _buildPersonCard(person, index);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonCard(Map<String, TextEditingController> person, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hành khách ${index + 1}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: person["name"],
              decoration: InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: person["phone"],
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.error != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  text: "Thêm người",
                  icon: Icons.person_add,
                  onPressed: () => context.read<BookingBloc>().add(AddPersonEvent()),
                ),
                _buildButton(
                  text: "Xóa người",
                  icon: Icons.person_remove,
                  onPressed: state.listPerson.length > 1
                      ? () => context.read<BookingBloc>().add(RemovePersonEvent())
                      : null,
                ),
                _buildButton(
                  text: "Đặt tour",
                  icon: Icons.book_online,
                  onPressed: () {
                    context.read<BookingBloc>().add(SubmitBookingEvent(context));
                  },
                  isPrimary: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isPrimary ? Colors.blue : null,
        foregroundColor: isPrimary ? Colors.white : null,
      ),
    );
  }
}