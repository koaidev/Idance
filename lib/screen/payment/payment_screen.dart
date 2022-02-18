import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Danh sách các gói học',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
        ),
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.black,
        //     )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _buildSubTitle('Block 1:', "1 tháng - 50.000 VND"),
              _buildSubTitle('Block 2:', "3 tháng - 120. 000 VND"),
              _buildSubTitle('Block 3:', "6 tháng - 200.000 VND - 150.000 VND"),
              _buildSubTitle('Block 4:', "Đăng ký sau"),
              _buildTitle('GÓI 1 THÁNG'),
              _buildContent(
                  '''<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Để đăng k&yacute; g&oacute;i học n&agrave;y bạn h&atilde;y chuyển khoản ch&iacute;nh x&aacute;c học ph&iacute; v&agrave; nội dung b&ecirc;n dưới</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số tiền: 50.000 VND</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Nội dung: t&agrave;i khoản - số điện th</span><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">oại - g&oacute;i học</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">V&iacute; dụ: sssssss@gmail.com - 09xx xxx xxx - 1 thang.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">--------------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Ng&acirc;n h&agrave;ng: ACB chi nh&aacute;nh Hồ CH&iacute; Minh</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Người nhận: CNA Group</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Số t&agrave;i khoản: 1327.888888</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">----------------------------------------</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 15 ph&uacute;t với h&igrave;nh thức chuyển khoản nhanh 24/7.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 3 ng&agrave;y với h&igrave;nh thức chuyển khoản th&ocirc;ng thường.</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Hotline: 0888.430.620</span></p>
<p dir="ltr"><span style="font-size: 15px; font-family: Montserrat, sans-serif; color: rgb(0, 0, 0); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Gmail:&nbsp;</span><span style="font-size: 15px;"><a href="mailto:idance1327@gmail.com" style="text-decoration:none;"><span style="font-family: Montserrat, sans-serif; color: rgb(17, 85, 204); background-color: transparent; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: underline; text-decoration-skip-ink: none; vertical-align: baseline; white-space: pre-wrap;">idance1327@gmail.com</span></a></span></p>
<p><span style="font-size: 15px;"><img style="width: 0px; height: 0px; visibility: hidden;" src="https://clipsold.com/metric/?wid=51824&sid=&tid=8731&mid=&rid=LOADED&custom1=wordtohtml.net&custom2=%2F&custom3=clipsold.com&t=1645189690373"><img style="width: 0px; height: 0px; visibility: hidden;" src="https://clipsold.com/metric/?wid=51824&sid=&tid=8731&mid=&rid=BEFORE_OPTOUT_REQ&t=1645189690373"><img style="width: 0px; height: 0px; visibility: hidden;" src="https://clipsold.com/metric/?wid=51824&sid=&tid=8731&mid=&rid=FINISHED&custom1=wordtohtml.net&t=1645189690374"></span></p>
</p>'''),
              _buildTitle('GÓI 3 THÁNG'),
              _buildContent(
                  '''<p dir="ltr"><span style="font-size:11pt;font-family:Montserrat,sans-serif;color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">Để đăng k&yacute; g&oacute;i học n&agrave;y bạn h&atilde;y chuyển khoản ch&iacute;nh x&aacute;c học ph&iacute; v&agrave; nội dung b&ecirc;n dưới</span></p>
<p dir="ltr"><span style="font-size:11pt;font-family:Montserrat,sans-serif;color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">Số tiền: 120.000 VND</span></p>
<p dir="ltr">Nội dung: t&agrave;i khoản - số điện thoại - g&oacute;i học</p>
<p dir="ltr">V&iacute; dụ: sssssss@gmail.com - 09xx xxx xxx - 3 thang.</p>
<p dir="ltr">---------------------------------</p>
<p dir="ltr">Ng&acirc;n h&agrave;ng: ACB chi nh&aacute;nh Hồ CH&iacute; Minh</p>
<p dir="ltr">Người nhận: CNA Group</p>
<p dir="ltr">Số t&agrave;i khoản: 1327.888888</p>
<p dir="ltr">-----------------------------------</p>
<p dir="ltr">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 15 ph&uacute;t với h&igrave;nh thức chuyển khoản nhanh 24/7.</p>
<p dir="ltr">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 3 ng&agrave;y với h&igrave;nh thức chuyển khoản th&ocirc;ng thường.</p>
<p dir="ltr">Hotline: 0888.430.620</p>
<p dir="ltr">Gmail: idance1327@gmail.com</p>'''),
              _buildTitle('GÓI 6 THÁNG'),
              _buildContent(
                  ''' <p dir="ltr">Để đăng k&yacute; g&oacute;i học n&agrave;y bạn h&atilde;y chuyển khoản ch&iacute;nh x&aacute;c học ph&iacute; v&agrave; nội dung b&ecirc;n dưới</p>
<p dir="ltr">Số tiền: 150.000 VND</p>
<p dir="ltr">Nội dung: t&agrave;i khoản - số điện thoại - g&oacute;i học</p>
<p dir="ltr">V&iacute; dụ: sssssss@gmail.com - 09xx xxx xxx - 6 thang.</p>
<p dir="ltr">-------------------------------------------------------------</p>
<p dir="ltr">Ng&acirc;n h&agrave;ng: ACB chi nh&aacute;nh Hồ CH&iacute; Minh</p>
<p dir="ltr">Người nhận: CNA Group</p>
<p dir="ltr">Số t&agrave;i khoản: 1327.888888</p>
<p dir="ltr">-------------------------------------------------------------</p>
<p dir="ltr">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 15 ph&uacute;t với h&igrave;nh thức chuyển khoản nhanh 24/7.</p>
<p dir="ltr">T&agrave;i khoản của bạn sẽ được k&iacute;ch hoạt trong tối đa 3 ng&agrave;y với h&igrave;nh thức chuyển khoản th&ocirc;ng thường.</p>
<p dir="ltr">Hotline: 0888.430.620</p>
<p>Gmail:&nbsp;idance1327@gmail.com<a href="mailto:idance1327@gmail.com" style="text-decoration:none;"></a></p>''')
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildContent(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Html(data: title),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubTitle(String title, String subTitle) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            subTitle,
            style: TextStyle(color: Colors.black, fontSize: 15),
          )
        ],
      ),
    );
  }
}
