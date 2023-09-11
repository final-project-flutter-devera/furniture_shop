import 'package:flutter/material.dart';

extension LocalizationExt on BuildContext {
  String localize(String value) {
    final code = AppLocalization.of(this).locale.languageCode;
    final database = AppLocalization._localizedValues;
    if (database.containsKey(code)) {
      return database[code]?[value] ?? '-';
    }
    return database['en']?[value] ?? '-';
  }
}

class AppLocalization {
  final Locale locale;

  const AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) =>
      Localizations.of<AppLocalization>(context, AppLocalization)!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      //general
      'label_yes': 'Yes',
      'label_no': 'No',

      ///boarding
      'boarding_title_1': 'MAKE YOUR',
      'boarding_title_2': 'HOME BEAUTIFUL',
      'boarding_description':
          'The best simple place where you discover most wonderful furnitures and make your home beautiful',
      'label_get_started': 'Get Started',

      ///Login
      'welcome_1': 'Hello!',
      'welcome_2': "WELCOME BACK",
      'label_email': 'Email',
      'label_password': 'Password',
      'label_forgot_password': "Forgot Password",
      'label_login': 'Log in',
      'label_signup': 'SIGN UP',
      'check_verify_mail': 'Please check inbox & verify mail',
      'user-not-found': 'User not found',
      'wrong-password': 'Your password provided is wrong',
      'check_fill_all': 'Please fill al fields',

      ///Sign up
      'welcome': 'WELCOME',
      'label_name': 'Name',
      //label_email
      //label_password
      'label_confirm_password': 'Confirm Password',
      'label_sign_up': 'SIGN UP',
      'sign_in_reminder': 'Already have account?',
      'label_sign_in': 'SIGN IN',

      ///Home
      'home_app_bar_title_1': 'Make home',
      'home_app_bar_title_2': 'BEAUTIFUL',
      'label_home_popular_tab_bar': 'Popular',
      'label_home_popular_chair': 'Chair',
      'label_home_popular_table': 'Table',
      'label_home_popular_armchair': 'Armchair',
      'label_home_popular_bed': 'Bed',
      'label_home_popular_lamp': 'Lamp',

      ///Product
      'label_review': 'Reviews',
      'label_add_to_cart': 'Add to cart',
      'label_visit_vendor': 'Visit',

      ///Favorite
      'favorite_app_bar_title': 'Favorites',
      'label_add_all_to_cart': 'Add all to my cart',

      ///Cart
      'cart_app_bar_title': 'My cart',
      'label_enter_promo_code': 'Enter your promo code',
      'label_total': 'Total',
      'label_check_out': 'Check out',

      ///Check out
      'check_out_app_bar_title': "Check out",
      'label_shipping_address': 'Shipping Address',
      'label_payment_method': 'Payment',
      'label_delivery_method': 'Delivery method',
      'label_order_price': 'Order',
      'label_delivery_fee': 'Delivery',
      'label_total_price': 'Total',
      'label_submit_order': 'SUBMIT ORDER',

      ///Notification
      'notification_app_bar_title': 'Notification',
      //Use .replace() to replace with actual order number
      'order_confirmed': 'Your order #%variable has been confirmed',
      'order_canceled': 'Your order #%variable has been canceled',
      'order_shipped': 'Your order #%variable has been shipped successfully',
      'label_new': 'New',
      'label_hot': 'HOT',

      ///Congrats
      'congrats_title': 'SUCCESS!',
      'congrats_message':
          'Your order will be delivered soon. Thank you for choosing our app!',
      'label_track_order': 'Track your orders',
      'label_back_to_home': "BACK TO HOME",

      ///Review
      'review_app_bar_title': "Rating & Review",
      //'label_review'
      'label_write_review': 'Write a review',

      ///Profile
      'profile_app_bar_title': "Profile",
      'my_order_option': 'My orders',
      'my_order_description': 'Already have %variable orders',
      'shipping_addresses_option': 'Shipping Addresses',
      'shipping_addresses_description': '%variable Addresses',
      'payment_methods_option': 'Payment Method',
      'payment_method_description': 'You have %variable cards',
      'my_reviews_option': 'My reviews',
      'my_reviews_description': 'Reviews for %variable items',
      'setting_option': 'Setting',
      'setting_description': 'Notification, Password, FAQ, Contact,...',

      ///Order
      'order_app_bar_title': 'My order',
      'label_delivered': 'Delivered',
      'label_processing': 'Processing',
      'label_canceled': 'Canceled',
      'order_card_title': 'Order No%variable',
      'order_card_quantity': 'Quantity',
      'order_card_total': 'Total Amount: ',
      'order_card_detail': 'Detail',

      ///Shipping Address
      'shipping_address_app_bar_title': "Shipping address",
      'use_address': 'Use as the shipping address',

      ///Payment Method
      'payment_method_app_bar_title': 'Payment method',
      'card_holder_name': 'Card Holder Name',
      'card_expiry_date': 'Expiry Date',
      'use_payment_method': 'Use as default payment method',

      ///My reviews
      'my_review_app_bar_title': 'My reviews',

      ///Add Shipping Address
      'add_shipping_address_app_bar_title': 'Add shipping address',
      'label_full_name': 'Recipient name',
      'place_holder_full_name': 'Ex: Bruno Pham',
      'label_address': 'Address',
      'place_holder_address': 'Ex: 25 Robert Latouche Street',
      'label_zipcode': 'Zipcode (Postal Code)',
      'place_holder_zipcode': '900000',
      'label_country': 'Country',
      'place_holder_country': "Select Country",
      'label_place': 'Street/Commune',
      'place_holder_place': 'Lower Manhattan',
      'label_city': 'City',
      'app_bar_title_edit_shipping_address': 'Edit Shipping Address',
      'place_holder_city': 'Select City',
      'label_district': 'District',
      'place_holder_district': 'Select District',
      'label_empty_field': "can't be empty",
      'message_no_address': 'You have no delivery addresses.',
      'label_pick_a_location': 'Pick a location on the map',
      'error_message_empty_address': 'Please fill all your address information',
      'label_save_button': 'SAVE ADDRESS',
      'mapbox_app_bar_title': 'Pick an address',
      'title_current_location': 'Your current location',
      'title_chosen_location': 'Your chosen location',
      'label_choose_current_location': 'Choose current location',
      'location_not_chosen': 'You have not choose a location',
      'label_choose_as_delivery_address': 'Choose as your delivery address',
      'alert_box_title_delete_address': 'Delete this address?',
      'alert_box_title_choose_as_delivery_address':
          'Choose this address as your deliver address?',
      'label_search_for_address': 'Search for an address...',
      'alert_box_title_address_not_chosen': 'You have not chosen an address',
      'hint_text_address_search': 'Search for an address...',

      'label_move_to_current_location': 'Move to your current location',

      ///ADD PAYMENT
      'add_payment_app_bar_title': 'Add payment method',
      // 'card_holder_name': 'Card Holder Name',
      // 'card_expiry_date': 'Expiry Date',
      'label_card_holder_name': 'Ex: Bruno Pham',
      'label_cvv': 'CVV',

      ///Setting
      'label_personal_information': 'Personal Information',
      // 'label_name': ,
      // 'label_email':
      // 'label_password:'
      'label_notification': 'Notification',
      'label_sales': 'Sales',
      'label_new_arrivals': 'New arrivals',
      'label_delivery_status_changes': 'Delivery status changes',
      'label_help_center': 'Help Center',
      'label_faq': 'FAQ',
      'label_contact': 'Contact us',
    },
    'vi': <String, String>{
      //general
      'label_yes': 'Có',
      'label_no': 'Không',

      ///Boarding
      'boarding_title_1': 'TRANG TRÍ',
      'boarding_title_2': 'NGÔI NHÀ CỦA BẠN',
      'boarding_description':
          'Nơi tốt nhất và dễ nhất để khám phá nội thất tuyệt vời nhất và biến ngôi nhà của bạn trở nên đẹp hơn',
      'label_get_started': 'Bắt đầu',

      ///Login
      'welcome_1': 'Xin chào!',
      'welcome_2': "CHÀO MỪNG TRỞ LẠI",
      'label_email': 'Email',
      'label_password': 'Mật khẩu',
      'label_forgot_password': "Quên mật khẩu",
      'label_login': 'Đăng nhập',
      'label_signup': 'ĐĂNG KÝ',
      'check_verify_mail': 'Vui lòng kiểm tra email để xác nhận',
      'user-not-found': 'Người dùng không tồn tại',
      'wrong-password': 'Mật khẩu được cung cấp không chính xác',
      'check_fill_all': 'Vui lòng điền hết chỗ trống',

      ///Sign up
      'welcome': 'CHÀO MỪNG',
      'label_name': 'Họ tên',
      //label_email
      //label_password
      'label_confirm_password': 'Xác nhận mật khẩu',
      'label_sign_up': 'ĐĂNG KÝ',
      'sign_in_reminder': 'Đã có tài khoản?',
      'label_sign_in': 'ĐĂNG NHẬP',

      ///Home
      'label_home_app_bar_title_1': 'Trang trí',
      'label_home_app_bar_title_2': 'NGÔI NHÀ',
      'label_home_popular_tab_bar': 'Phổ biến',
      'label_home_popular_chair': 'Ghế',
      'label_home_popular_table': 'Bàn',
      'label_home_popular_armchair': 'Ghế bành',
      'label_home_popular_bed': 'Giường',
      'label_home_popular_lamp': 'Đèn',

      ///Product
      'label_review': 'Đánh giá',
      'label_add_to_cart': 'Thêm vào giỏ hàng',
      'label_visit_vendor': 'Ghé thăm',

      ///Favorite
      'favorite_app_bar_title': 'Yêu thích',
      'label_add_all_to_cart': 'Thêm tất cả vào giỏ hàng',

      ///Cart
      'cart_app_bar_title': 'Giỏ hàng của tôi',
      'label_enter_promo_code': 'Nhập mã giới thiệu',
      'label_total': 'Tổng',
      'label_check_out': 'Thanh toán',

      ///Check out
      'check_out_app_bar_title': "Thanh toán",
      'label_shipping_address': 'Địa chỉ giao hàng',
      'label_payment_method': 'Phương thức thanh toán',
      'label_delivery_method': 'Phương thức giao hàng',
      'label_order_price': 'Đơn hàng',
      'label_delivery_fee': 'Vận chuyển',
      'label_total_price': 'Tổng',
      'label_sumbit_order': 'XÁC NHẬN ĐƠN HÀNG',

      ///Notification
      'notification_app_bar_title': 'Thông báo',
      //Use .replace() to replace with actual order number
      'order_confirmed': 'Đơn hàng #%variable đã được xác nhận',
      'order_canceled': 'Đơn hàng #%variable đã được hủy',
      'order_shipped': 'Đơn hàng #%variable đã được giao thành công',
      'label_new': 'Mới',
      'label_hot': 'NÓNG',

      ///Congrats
      'congrats_title': 'THÀNH CÔNG!',
      'congrats_message':
          'Đơn hàng của bạn sẽ được giao sớm. Cảm ơn đã sử dụng ứng dụng của chúng tôi!',
      'label_track_order': 'Theo dõi đơn hàng',
      'label_back_to_home': "QUAY VỀ TRANG CHỦ",

      ///Review
      'review_app_bar_title': "Đánh giá và nhận xét",
      //'label_review'
      'label_write_review': 'Viết một nhận xét',

      ///Profile
      'profile_app_bar_title': "Hồ sơ",
      'my_order_option': 'Đơn hàng của tôi',
      'my_order_description': 'Đã có %variable đơn hàng',
      'shipping_addresses_option': 'Địa chỉ giao hàng',
      'shipping_addresses_description': '%variable địa chỉ',
      'payment_methods_option': 'Phương thức thanh toán',
      'payment_method_description': 'Banh có %variable thẻ',
      'my_reviews_option': 'Nhận xét của tôi',
      'my_reviews_description': 'Nhận xét cho %variable vật phẩm',
      'setting_option': 'Tùy chỉnh',
      'setting_description':
          'Thông báo, mật khẩu, câu hỏi thường gặp, liên hệ,...',

      ///Order
      'order_app_bar_title': 'Đơn hàng của tôi',
      'label_delivered': 'Đã giao',
      'label_processing': 'Chờ xác nhận',
      'label_canceled': 'Đã hủy',
      'order_card_title': 'Đơn hàng số %variable',
      'order_card_quantity': 'Số lượng',
      'order_card_total': 'Tổng giá tiền: ',
      'order_card_detail': 'Chi tiết',

      ///Shipping
      'shipping_address_app_bar_title': "Địa chỉ giao hàng",
      'use_address': 'Sử dụng làm địa chỉ giao hàng',

      ///Payment Method
      'payment_method_app_bar_title': 'Phương thức thanh toán',
      'card_holder_name': 'Tên chủ thẻ',
      'card_expiry_date': 'Ngày hết hạn',
      'use_payment_method': 'Sử dụng làm phương thức thanh toán mặc định',

      ///My reviews
      'my_review_app_bar_title': 'Nhận xét của tôi',

      ///Add Shipping Address
      'add_shipping_address_app_bar_title': 'Thêm địa chỉ giao hàng',
      'label_full_name': 'Tên người nhận',
      'place_holder_full_name': 'VD: Phạm Văn A',
      'label_address': 'Địa Chỉ',
      'place_holder_address': 'VD: 25 Lê Văn Việt',
      'label_zipcode': 'Mã Zip (Mã bưu chính)',
      'place_holder_zipcode': '700000',
      'label_country': 'Quốc gia',
      'place_holder_country': "Chọn quốc gia",
      'label_city': 'Thành phố',
      'app_bar_title_edit_shipping_address': 'Chỉnh sửa địa chỉ giao hàng',
      'place_holder_place': 'Bình Thạnh',
      'label_place': 'Xã/Phường/Thị Trấn',
      'place_holder_city': 'Chọn thành phố',
      'label_district': 'Quận/Huyện',
      'place_holder_district': 'Chọn quận/huyện',
      'label_empty_field': "không thể trống",
      'label_pick_a_location': 'Chọn vị trí trên bản đồ',
      'message_no_address': 'Bạn không có địa chỉ giao hàng.',
      'error_message_empty_address': 'Vui lòng điền thông tin địa chỉ',
      'label_save_button': 'LƯU ĐỊA CHỈ',
      'mapbox_app_bar_title': 'Chọn một địa chỉ',
      'title_current_location': 'Vị trí hiện tại',
      'title_chosen_location': 'Vị trí đã chọn',
      'label_choose_current_location': 'Chọn vị trí hiện tại',
      'location_not_chosen': 'Bạn chưa chọn địa chỉ',
      'label_choose_as_delivery_address': 'Chọn làm địa chỉ giao hàng',
      'alert_box_title_delete_address': 'Xóa địa chỉ này?',
      'alert_box_title_choose_as_delivery_address':
          'Chọn địa chỉ này làm địa chỉ giao hàng?',
      'title_move_to_current_location': 'Di chuyển đến vị trí hiện tại của bạn',
      'label_search_for_address': 'Tìm một địa chỉ...',
      'alert_box_title_address_not_chosen': 'Bạn chưa chọn địa chỉ giao hàng',
      'hint_text_address_search': 'Tìm kiếm một địa chỉ...',

      ///ADD PAYMENT
      'add_payment_app_bar_title': 'Thêm phương thức thanh toán',
      // 'card_holder_name': 'Card Holder Name',
      // 'card_expiry_date': 'Expiry Date',
      'label_card_holder_name': 'VD: Phạm Văn A',
      'label_cvv': 'CVV',

      ///Setting
      'label_personal_information': 'Thông tin cá nhân',
      // 'label_name': ,
      // 'label_email':
      // 'label_password:'
      'label_notification': 'Thông báo',
      'label_sales': 'Ưu đãi',
      'label_new_arrivals': 'Nội thất mới',
      'label_delivery_status_changes': 'Tình trạng giao hàng thay đổi',
      'label_help_center': 'Trung tâm trợ giúp',
      'label_faq': 'Câu hỏi thường gặp',
      'label_contact': 'Liên hệ chúng tôi',
    },
  };
}
