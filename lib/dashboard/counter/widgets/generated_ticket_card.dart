import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';

class TicketDisplay extends StatefulWidget {
  const TicketDisplay({Key? key}) : super(key: key);

  @override
  _TicketDisplayState createState() => _TicketDisplayState();
}

class _TicketDisplayState extends State<TicketDisplay> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GeneratedTickets>>(
        stream: TicketProvider.of(context).recentTicketStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data!.map((e) => TicketCard(generatedTicket: e)).toList(),
            ),
          );
        });
  }
}

class TicketCard extends StatelessWidget {
  GeneratedTickets generatedTicket;
  TicketCard({Key? key, required this.generatedTicket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:4.0,horizontal: 8),
      child: Material(
        elevation: 8,
        shadowColor: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: [
              Container(
                width: 250,
                height: 68,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Container(
                      width: 48,
                      height: 48,
                      child: SvgPicture.asset(
                        'assets/icons/ticket.svg',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          generatedTicket.number,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '₹ ${generatedTicket.price.toString()}',
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        )
                      ],
                    )
                  ]),
                ),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    // child: Text(DateFormat().format(generatedTicket.issuedTs).toString()),
                    child: Text(
                      DateFormat('h:mm a').format(generatedTicket.issuedTs).toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
