import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/request/request_status.dart';
import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';

import '../../common/checkable_icon_container.dart';
import '../../common/title_text.dart';
import '../../../../utils/size_config.dart';
import 'request_tag.dart';
import '../../ui_widgets/glass_rounded_container.dart';

class RequestLineItem extends StatefulWidget {
  final double height;
  final RequestViewModel requestViewModel;

  const RequestLineItem({
    super.key,
    required this.requestViewModel,
    this.height = 150,
  });

  @override
  State<RequestLineItem> createState() => _RequestLineItemState();
}

class _RequestLineItemState extends State<RequestLineItem> {
  bool checkAssignedClerk = false;
  bool checkCompletedTask = false;

  @override
  Widget build(BuildContext context) {
    RequestViewModel request = widget.requestViewModel;
    bool isClerk = Provider.of<UserViewModel>(context).isClerk;
    checkAssignedClerk = request.clerk != null ? true : false;
    checkCompletedTask =
        request.status == RequestStatus.completed ? true : false;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the screen width and height from the MediaQuery object
        double screenWidth = constraints.maxWidth;

        // Determine if the screen width is lower than a certain threshold
        bool hideImage = screenWidth < 315;
        return GlassRoundedContainer(
          margin: EdgeInsets.only(
            bottom: getProportionateScreenHeight(20),
            left: getProportionateScreenWidth(3),
            right: getProportionateScreenWidth(3),
          ),
          itemPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          radius: BorderRadius.circular(20.0),
          opacity: 0.8,
          enableBorder: true,
          enableShadow: false,
          child: Container(
            color: const Color.fromARGB(190, 255, 255, 255),
            height: widget.height,
            child: Row(
              children: <Widget>[
                hideImage
                    ? Container()
                    : AspectRatio(
                        aspectRatio: 0.8,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 0),
                                      blurRadius: 5,
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: kIsWeb || !Platform.environment.containsKey('FLUTTER_TEST')
                                        ? NetworkImage(
                                        request.products[0].imageUrl!) : Image.asset('assets/images/test.png').image,
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: getProportionateScreenWidth(3)),
                    child: ExpansionTile(
                      title: TitleText(
                        color: Colors.black87,
                        text: '${request.products[0].title}',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const TitleText(
                                text: 'Requested size: ',
                                color: Colors.teal,
                                fontSize: 12,
                              ),
                              TitleText(
                                text: '${request.products[0].sizes![0]}',
                                fontSize: 12,
                                color: Colors.grey,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const TitleText(
                                text: 'ID: ',
                                color: Colors.teal,
                                fontSize: 12,
                              ),
                              Flexible(
                                child: TitleText(
                                  text: request.id,
                                  fontSize: 11,
                                  color: Colors.grey,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              !isClerk
                                  ? RequestTag(
                                      status: request.status,
                                      hideDetails: false)
                                  : const SizedBox(width: 0)
                            ],
                          ),
                        ],
                      ),
                      trailing: CheckableIconContainer(
                        value: checkCompletedTask,
                        icon: Icons.check,
                        onChanged: (bool value) {
                          if (request.status == RequestStatus.accepted) {
                            setState(() {
                              checkCompletedTask = value;
                            });
                            if (checkCompletedTask) {
                              request.updateStatus(RequestStatus.completed);
                            }
                          }
                        },
                        disabled: request.status == RequestStatus.pending,
                        hidden: request.status == RequestStatus.completed ||
                            isClerk,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
