import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxoo/service/authentication_service.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({Key? key}) : super(key: key);

  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  String title = '';
  String content = '';
  Function? action1;

  void handleAction(int index) {
    if (index == 1) {
      title = '1 tháng'.toUpperCase();
      content =
          '''<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Để đăng k&yacute; g&oacute;i học n&agrave;y bạn h&atilde;y chuyển khoản ch&iacute;nh x&aacute;c học ph&iacute; v&agrave; nội dung b&ecirc;n dưới</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số tiền: 50.000 VNĐ</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Nội dung: t&agrave;i khoản - số điện th</span><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">oại - g&oacute;i học</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Vui lòng soạn: ${AuthService().getUser()?.email != null ? AuthService().getUser()?.email : 'Thêm Email đăng ký của bạn'} - SĐT của bạn - 1 thang.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">--------------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Ng&acirc;n h&agrave;ng: ACB chi nh&aacute;nh Hồ CH&iacute; Minh</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Người nhận: CNA Group</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số t&agrave;i khoản: 1327.888888</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">----------------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 15 ph&uacute;t với h&igrave;nh thức chuyển khoản nhanh 24/7.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 3 ng&agrave;y với h&igrave;nh thức chuyển khoản th&ocirc;ng thường.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Hotline: 0888.430.620</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Gmail:&nbsp;</span><span style="font-size: 15px;"><a href="mailto:idance1327@gmail.com" style="text-decoration:none;"><span style="font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: underline; text-decoration-skip-ink: none; vertical-align: baseline; white-space: pre-wrap;">idance1327@gmail.com</span></a></span></p>
<p><span style="font-size: 15px;"><img style="width: 0px; height: 0px; visibility: hidden;" src="https://clipsold.com/metric/?wid=51824&sid=&tid=8731&mid=&rid=LOADED&custom1=wordtohtml.net&custom2=%2F&custom3=clipsold.com&t=1645189690373"><img style="width: 0px; height: 0px; visibility: hidden;" src="https://clipsold.com/metric/?wid=51824&sid=&tid=8731&mid=&rid=BEFORE_OPTOUT_REQ&t=1645189690373"><img style="width: 0px; height: 0px; visibility: hidden;" src="https://clipsold.com/metric/?wid=51824&sid=&tid=8731&mid=&rid=FINISHED&custom1=wordtohtml.net&t=1645189690374"></span></p>
</p>''';
      action1 = () {
        Clipboard.setData(ClipboardData(text: "mail - SĐT của bạn - 01 thang"));
        Fluttertoast.showToast(
            msg:
                "Đã sao chép: ${AuthService().getUser()?.email} - SĐT của bạn - 01 thang",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      };
    } else if (index == 2) {
      title = '3 tháng'.toUpperCase();
      content =
          '''<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Để đăng k&yacute; g&oacute;i học n&agrave;y bạn h&atilde;y chuyển khoản ch&iacute;nh x&aacute;c học ph&iacute; v&agrave; nội dung b&ecirc;n dưới</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số tiền: 120.000 VNĐ</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Nội dung: t&agrave;i khoản - số điện thoại - g&oacute;i học</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Vui lòng soạn: ${AuthService().getUser()?.email != null ? AuthService().getUser()?.email : 'Thêm Email đăng ký của bạn'} - SĐT của bạn - 3 thang.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">---------------------------------</p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Ng&acirc;n h&agrave;ng: ACB chi nh&aacute;nh Hồ CH&iacute; Minh</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Người nhận: CNA Group</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số t&agrave;i khoản: 1327.888888</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">-----------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 15 ph&uacute;t với h&igrave;nh thức chuyển khoản nhanh 24/7.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 3 ng&agrave;y với h&igrave;nh thức chuyển khoản th&ocirc;ng thường.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Hotline: 0888.430.620</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Gmail: idance1327@gmail.com</span></p>''';
      action1 = () {
        Clipboard.setData(ClipboardData(
            text:
                "${AuthService().getUser()?.email} - SĐT của bạn - 03 thang"));
        Fluttertoast.showToast(
            msg:
                "Đã sao chép: ${AuthService().getUser()?.email} - SĐT của bạn - 03 thang",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      };
    } else {
      title = '6 tháng'.toUpperCase();
      content =
          ''' <p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Để đăng k&yacute; g&oacute;i học n&agrave;y bạn h&atilde;y chuyển khoản ch&iacute;nh x&aacute;c học ph&iacute; v&agrave; nội dung b&ecirc;n dưới</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số tiền: <del>200.000 VNĐ</del>(150.000 VNĐ) </span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Nội dung: t&agrave;i khoản - số điện thoại - g&oacute;i học</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Vui lòng soạn: ${AuthService().getUser()?.email != null ? AuthService().getUser()?.email : 'Thêm Email đăng ký của bạn'} - SĐT của bạn - 6 thang.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">-------------------------------------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Ng&acirc;n h&agrave;ng: ACB chi nh&aacute;nh Hồ CH&iacute; Minh</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Người nhận: CNA Group</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số t&agrave;i khoản: 1327.888888</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">-------------------------------------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 15 ph&uacute;t với h&igrave;nh thức chuyển khoản nhanh 24/7.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 3 ng&agrave;y với h&igrave;nh thức chuyển khoản th&ocirc;ng thường.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Hotline: 0888.430.620</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(255,255,255); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Gmail:&nbsp;idance1327@gmail.com<a href="mailto:idance1327@gmail.com" style="text-decoration:none;"></a></span></p>''';
      action1 = () {
        Clipboard.setData(ClipboardData(
            text:
                "${AuthService().getUser()?.email} - SĐT của bạn - 06 thang"));
        Fluttertoast.showToast(
            msg:
                "Đã sao chép: ${AuthService().getUser()?.email} - SĐT của bạn - 06 thang",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      };
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)!.settings.arguments as int;
    handleAction(index);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildContent(content),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildContent(String title) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Color(0xffA22447).withOpacity(.05),
                offset: Offset(0, 0),
                blurRadius: 20,
                spreadRadius: 3)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Html(data: title),
          Divider(
            height: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: _buildActionCopy('Copy cú pháp', action: action1)),
              Expanded(
                  child: _buildActionCopy('Copy số tài khoản', action: () {
                Clipboard.setData(ClipboardData(text: "1327888888"));
                Fluttertoast.showToast(
                    msg: "Đã sao chép: 1327888888",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              })),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionCopy(String title, {Function? action}) {
    return GestureDetector(
      onTap: () {
        action?.call();
      },
      child: Row(
        children: [
          Icon(
            Icons.copy,
            color: Colors.white,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
