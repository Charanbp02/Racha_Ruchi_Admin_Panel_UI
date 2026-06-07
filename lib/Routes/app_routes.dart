abstract class Routes {
  Routes._();
  static const SIDEBAR = '/';
  static const DASHBOARD = '/dashboard';
  static const CATEGORY = '/category';
  static const CATEGORY_ADD = '/category/add';
  static const CATEGORY_MANAGE = '/category/manage';
  static const CATEGORY_SUB = '/category/sub';
  static const CATEGORY_SETTINGS = '/category/settings';
  static const ORDERS = '/orders';
  static const PRODUCTS = '/products';
  static const VIDEOS = '/videos';
  static const USERS = '/users';
  static const PENDING_APPROVALS = '/pending-approvals';
  static const LOGIN = '/login';
  static const SETTINGS = '/settings';
  static const TOP_RECIPES_VIDEOS = '/top-recipes-videos';
  static const BANNERS = '/banners';
  static const SHORTS = '/shorts';
  static const COUPONS = '/coupons';
}

abstract class AppRoutes {
  AppRoutes._();
  // Change INITIAL to LOGIN instead of SIDEBAR
  static const INITIAL = Routes.LOGIN; // Changed from SIDEBAR to LOGIN
  static const DASHBOARD = Routes.DASHBOARD;
  static const CATEGORY = Routes.CATEGORY;
  static const ORDERS = Routes.ORDERS;
  static const CATEGORY_ADD = Routes.CATEGORY_ADD;
  static const CATEGORY_MANAGE = Routes.CATEGORY_MANAGE;
  static const CATEGORY_SUB = Routes.CATEGORY_SUB;
  static const CATEGORY_SETTINGS = Routes.CATEGORY_SETTINGS;
  static const PENDING_APPROVALS = Routes.PENDING_APPROVALS;
  static const LOGIN = Routes.LOGIN;
  static const SETTINGS = Routes.SETTINGS;
  static const TOP_RECIPES_VIDEOS = Routes.TOP_RECIPES_VIDEOS;
  static const BANNERS = Routes.BANNERS;
  static const SHORTS = Routes.SHORTS;
  static const VIDEO = Routes.VIDEOS;
  static const COUPONS = Routes.COUPONS;
}
