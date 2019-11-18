import 'package:flutter/material.dart';
import 'package:flutter_app/models//screenmodel.dart';


class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with AutomaticKeepAliveClientMixin<CallScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: ListView.builder(
        itemCount: dummyDataCall.length,
        itemBuilder: (context, i) => Column(
          children: <Widget>[
            Divider(
              height: 10.0,
            ),
            ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                child: CustomCircleAvatar(
                  initials: "Loading",
                  myImage: dummyDataCall[i].netImg,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dummyDataCall[i].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    //new
                    margin: EdgeInsets.symmetric(horizontal: 4.0), //new
                    child: IconButton(
                      //new
                        icon: Icon(dummyDataCall[i].icono),
                        onPressed: () => ({})), //new
                  ),
                ],
              ),
              subtitle: Container(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(children: [
                  Text(
                    dummyDataCall[i].message,
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                  Text(
                    dummyDataCall[i].time,
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomCircleAvatar extends StatefulWidget {
  final NetworkImage myImage;
  final String initials;

  CustomCircleAvatar({this.myImage, this.initials});

  @override
  _CustomCircleAvatarState createState() => new _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar>
    with AutomaticKeepAliveClientMixin<CustomCircleAvatar> {
  bool _checkLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

//        ? new CircleAvatar(child: new Text(widget.initials))

    return _checkLoading == true
        ?  Text(widget.initials)
        :  CircleAvatar(
      backgroundImage: widget.myImage,
      foregroundColor: new Color(0xff25D366),
    );
  }
}