import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/pending_holiday_requests.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/pending_rtt_requests.dart';

class AllDemandsView extends StatefulWidget {
  final int type;
  AllDemandsView({Key? key, this.type = 0}) : super(key: key);
  @override
  _AllDemandsViewState createState() => _AllDemandsViewState();
}

class _AllDemandsViewState extends State<AllDemandsView> with SingleTickerProviderStateMixin {
  late final TabController _tabController = new TabController(length: 2, vsync: this, initialIndex: widget.type);
  final PendingHolidayRequests _holidayRequests = PendingHolidayRequests();
  final PendingRTTRequests _pendingRTTRequests = PendingRTTRequests();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Palette.gradientColor[0]
        ),
        title: Text("Toutes les demandes en attente".toUpperCase(),style: TextStyle(
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
          color: Palette.gradientColor[0]
        ),),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Row(
            children: [
              Container(
                height: 60,
                width: size.width > 900 ? size.width * .4 : size.width,
                child: TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  indicatorColor: Palette.gradientColor[0],
                  unselectedLabelColor: Colors.grey.shade400,
                  labelColor: Palette.gradientColor[0],
                  controller: _tabController,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.beach_access_outlined),
                      text: "Congés",
                    ),
                    Tab(
                      icon: Icon(Icons.hourglass_bottom_outlined),
                      text: "RTT",
                    )
                  ],
                ),
              ),
              Spacer()
            ],
          )
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            _holidayRequests,
            _pendingRTTRequests
          ],
        ),
      ),
    );
  }
}

