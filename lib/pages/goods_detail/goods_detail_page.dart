import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pingduoduo/pages/goods_detail/config_widget.dart';
import 'package:pingduoduo/pages/goods_detail/goods_evaluate_widget.dart';
import 'package:pingduoduo/pages/goods_detail/group_order_widget.dart';
import 'package:pingduoduo/pages/goods_detail/title_price_widget.dart';
import 'package:pingduoduo/util/image_utls.dart';
import 'package:pingduoduo/widgets/container_divider.dart';
import 'package:pingduoduo/widgets/image_text_widget.dart';
import 'package:pingduoduo/widgets/more_container_widget.dart';
import 'package:pingduoduo/widgets/triangle_shape.dart';

//商品详情
class GoodsDetailPage extends StatefulWidget {
  @override
  _GoodsDetailPageState createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage> {
  double _statusBarHeight;
  double _toolbarHeight;
  List<String> swiperData;

  double _appbarOpacity = 0.1;

  ScrollController _scrollController;

  @override
  void initState() {
    swiperData = [
      'https://t00img.yangkeduo.com/goods/images/2020-04-29/acdbfd36-caad-4831-8325-acd125f185a6.jpg',
      'https://t00img.yangkeduo.com/goods/images/2020-02-24/c23a3fa9-b3e7-4cf1-8bc6-a6f8b35e9a8b.jpg',
      'https://t00img.yangkeduo.com/goods/images/2020-02-24/444d353a-07ab-400c-8130-e5a9c13de4e3.jpg',
      'https://t00img.yangkeduo.com/goods/images/2020-02-24/53ed839c-75eb-413d-a9e9-c44d18e59827.jpg',
      'https://t00img.yangkeduo.com/goods/images/2020-02-24/5c32f8c8-0179-46b5-88e8-c3073b26ff02.jpg',
      'https://t00img.yangkeduo.com/goods/images/2020-02-24/77e48ba4-131e-4bdd-96f7-5dce906b2576.jpg'
    ];
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    double offset = _scrollController.offset;
    if (offset <= 100) {
      double opacity = offset / 100;
      if (opacity >= 0) {
        setState(() {
          _appbarOpacity = opacity;
        });
      }

    } else if (offset > 100 && _appbarOpacity < 1) {
      //快速滑动
      setState(() {
        _appbarOpacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _toolbarHeight = ScreenUtil().setHeight(100);

    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: ScreenUtil().screenHeight,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      _createSwiperWidget(),
                      SliverToBoxAdapter(
                        child: TitlePriceWidget(),
                      ),
                      SliverToBoxAdapter(child: GoodsConfigWidget()),
                      _createGoodsPromiseWidget(),
                      SliverToBoxAdapter(child: GroupOrderWidget()),  //拼单轮播
                      SliverToBoxAdapter(child: GoodsEvaluateWidget()),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 300,
                        ),
                      )
                    ],
                  )),
              //标题头
              Positioned(left: 0, right: 0, child: _createToolBarWidget()),
              //底部购买
              Positioned(
                  left: 0, right: 0, bottom: 0, child: _createBottomWidget())
            ],
          ),
        ),
      ),
    );
  }

  Widget _createToolBarWidget() {
    return Container(
      color: Colors.white.withOpacity(_appbarOpacity),
      height: _statusBarHeight + _toolbarHeight,
      padding: EdgeInsets.only(top: _statusBarHeight),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              ImageUtils.getSvgImagePath('back_black'),
              width: _toolbarHeight,
            ),
          ),
          Expanded(
              child: Offstage(
            child: Container(),
            offstage: true,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              ImageUtils.getImagePath('icons/share'),
            ),
          )
        ],
      ),
    );
  }

  //轮播图
  SliverToBoxAdapter _createSwiperWidget() {
    return SliverToBoxAdapter(
      child: Container(
        height: ScreenUtil().setHeight(1000),
        child: Swiper(
            itemCount: swiperData.length,
            autoplay: false,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: swiperData[index],
                fit: BoxFit.fill,
              );
            }),
      ),
    );
  }

  SliverToBoxAdapter _createGoodsPromiseWidget() {
    double itemHeight = ScreenUtil().setHeight(150);
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          ContainerDivider(child:
            Container(
                height: itemHeight,
                child: MoreContainerWidget(
                    child: Text('顺丰包邮  退货包运费 正品发票 全国联保',
                        style: TextStyle(color: Color(0xff58595b))),
                    paddingLeft: 10)),
            showBottomDivider: false,
          ),
          ContainerDivider(child:
            Container(
                height: itemHeight,
                child: MoreContainerWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(ImageUtils.getImagePath('icons/guarantee')),
                        Text('正品险由中国人保财险承保',style: TextStyle(color: Color(0xff58595b)))
                      ],
                    ),
                    paddingLeft: 5)),
            topDividerLeftMargin: 10,
            showBottomDivider: false,
          ),
          ContainerDivider(child:Container(
              height: itemHeight,
              child: MoreContainerWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(ImageUtils.getImagePath('icons/order')),
                      Text('「小米智能机畅销榜」前20名',style: TextStyle(color:const Color(0xff58595b)))
                    ],
                  ),
                  paddingLeft: 10)),topDividerLeftMargin: 10,)
        ],
      ),
    );
  }

  Widget _createBottomWidget() {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(160),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ImagetTextWidget(
              '店铺',
              'icons/store',
              filePath: true,
              imageSize: ScreenUtil().setWidth(70),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ImagetTextWidget(
              '收藏',
              'icons/like',
              filePath: true,
              imageSize: ScreenUtil().setWidth(70),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: ImagetTextWidget(
              '客服',
              'icons/message',
              filePath: true,
              imageSize: ScreenUtil().setWidth(70),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xfff3aba7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('¥5500',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('单独购买',
                      style: TextStyle(color: Colors.white, fontSize: 18))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xffe02e24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('¥5068',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('发起拼单',
                      style: TextStyle(color: Colors.white, fontSize: 18))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
