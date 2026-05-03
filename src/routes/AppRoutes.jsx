import { BrowserRouter, Routes, Route } from "react-router-dom";
import Dashboard from "../Pages/Dashboard/Dashboard";
import Sidebar from "../Components/Sidebar/sideBar";

// Import Dashboard Sub-pages
import TotalVideos from "../Pages/Dashboard/TotalVideos";
import PendingApprovals from "../Pages/Dashboard/PendingApprovals";
import TotalUsers from "../Pages/Dashboard/TotalUsers";
import TotalProducts from "../Pages/Dashboard/TotalProducts";
import RecentActivity from "../Pages/Dashboard/RecentActivity";

// Import Category Pages
import Category from "../Pages/Categories/Category";
import AddCategory from "../Pages/Categories/AddCategory";
import ManageCategories from "../Pages/Categories/ManageCategories";
import SubCategories from "../Pages/Categories/SubCategories";
import CategorySettings from "../Pages/Categories/CategorySettings";

// Import Order Pages
import Orders from "../Pages/Orders/Orders";
import AllOrders from "../Pages/Orders/AllOrders";
import NewOrders from "../Pages/Orders/NewOrders";
import ProcessingOrders from "../Pages/Orders/ProcessingOrders";
import CompletedOrders from "../Pages/Orders/CompletedOrders";
import CancelledOrders from "../Pages/Orders/CancelledOrders";
import ReturnOrders from "../Pages/Orders/ReturnOrders";

// Import Pending Pages
import Pending from "../Pages/Pending/Pending";
import PendingOrders from "../Pages/Pending/PendingOrders";
import PendingPayments from "../Pages/Pending/PendingPayments";
import PendingReviews from "../Pages/Pending/PendingReviews";
import PendingApproval from "../Pages/Pending/PendingApproval";

// Import Product Pages
import Products from "../Pages/Products/Products";
import AllProducts from "../Pages/Products/AllProducts";
import AddProduct from "../Pages/Products/AddProduct";
import ProductStock from "../Pages/Products/ProductStock";
import ProductCategories from "../Pages/Products/ProductCategories";
import ProductTags from "../Pages/Products/ProductTags";
import ProductReviews from "../Pages/Products/ProductReviews";
import EditProducts from "../Pages/Products/EditProducts";
import Videos from "../Pages/Videos/Videos";
import AllVideos from "../Pages/Videos/AllVideos";
import UploadVideo from "../Pages/Videos/UploadVideo";
import VideoCategories from "../Pages/Videos/VideoCategories";
import PopularVideos from "../Pages/Videos/PopularVideos";
import VideoRequests from "../Pages/Videos/VideoRequests";

// Import Shorts Pages
import Shorts from "../Pages/Shorts/Shorts";
import AllShorts from "../Pages/Shorts/AllShorts";
import UploadShort from "../Pages/Shorts/UploadShort";
import TrendingShorts from "../Pages/Shorts/TrendingShorts";
import ShortCategories from "../Pages/Shorts/ShortCategories";


// Import Settings Pages
import Settings from "../Pages/Settings/Settings";
import GeneralSettings from "../Pages/Settings/GeneralSettings";
import ProfileSettings from "../Pages/Settings/ProfileSettings";
import Notifications from "../Pages/Settings/Notifications";
import PaymentSettings from "../Pages/Settings/PaymentSettings";
import EmailSettings from "../Pages/Settings/EmailSettings";
import Integrations from "../Pages/Settings/Integrations";
import Security from "../Pages/Settings/Security";

// Import User Pages
import Users from "../Pages/Users/Users";
import AllUsers from "../Pages/Users/AllUsers";
import UserRoles from "../Pages/Users/UserRoles";
import Permissions from "../Pages/Users/Permissions";
import ActiveUsers from "../Pages/Users/ActiveUsers";
import BlockedUsers from "../Pages/Users/BlockedUsers";
import UserReports from "../Pages/Users/UserReports";
import AddUser from "../Pages/Users/AddUser";



function AppRoutes() { 
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Sidebar />}>
          {/* Main Dashboard */}
          <Route index element={<Dashboard />} />
          
          {/* Dashboard Sub-pages */}
          <Route path="total-videos" element={<TotalVideos />} />
          <Route path="pending-approvals" element={<PendingApprovals />} />
          <Route path="total-users" element={<TotalUsers />} />
          <Route path="total-products" element={<TotalProducts />} />
          <Route path="recent-activity" element={<RecentActivity />} />
          
          {/* Category Routes */}
          <Route path="category" element={<Category />} />
          <Route path="category/add" element={<AddCategory />} />
          <Route path="category/manage" element={<ManageCategories />} />
          <Route path="category/sub" element={<SubCategories />} />
          <Route path="category/settings" element={<CategorySettings />} />

          {/* Order Routes */}
          <Route path="orders" element={<Orders />} />
          <Route path="orders/all" element={<AllOrders />} />
          <Route path="orders/new" element={<NewOrders />} />
          <Route path="orders/processing" element={<ProcessingOrders />} />
          <Route path="orders/completed" element={<CompletedOrders />} />
          <Route path="orders/cancelled" element={<CancelledOrders />} />
          <Route path="orders/returns" element={<ReturnOrders />} />

          {/* Pending Routes */}
          <Route path="pending" element={<Pending />} /> 
          <Route path="pending/orders" element={<PendingOrders />} />
          <Route path="pending/payments" element={<PendingPayments />} />
          <Route path="pending/approval" element={<PendingApproval />} />
          <Route path="pending/reviews" element={<PendingReviews />} />

          {/* Product Routes */}
          <Route path="products" element={<Products />} />
          <Route path="products/all" element={<AllProducts />} />
          <Route path="products/add" element={<AddProduct />} />
          <Route path="products/stock" element={<ProductStock />} />
          <Route path="products/categories" element={<ProductCategories />} />
          <Route path="products/tags" element={<ProductTags />} />
          <Route path="products/reviews" element={<ProductReviews />} />
          <Route path="products/edit" element={<EditProducts />} />

          {/* Video Routes */}
          <Route path="videos" element={<Videos />} />
          <Route path="videos/all" element={<AllVideos />} />
          <Route path="videos/upload" element={<UploadVideo />} />
          <Route path="videos/categories" element={<VideoCategories />} />
          <Route path="videos/popular" element={<PopularVideos />} />
          <Route path="videos/requests" element={<VideoRequests />} />

          {/* Shorts Routes */}
         <Route path="shorts" element={<Shorts />} />
         <Route path="shorts/all" element={<AllShorts />} />
         <Route path="shorts/upload" element={<UploadShort />} />
         <Route path="shorts/trending" element={<TrendingShorts />} />
         <Route path="shorts/categories" element={<ShortCategories />} />

         {/* Settings Routes */}
         <Route path="settings" element={<Settings />} />
         <Route path="settings/general" element={<GeneralSettings />} />
         <Route path="settings/profile" element={<ProfileSettings />} />
         <Route path="settings/security" element={<Security />} />
         <Route path="settings/notifications" element={<Notifications />} />
         <Route path="settings/payment" element={<PaymentSettings />} />
         <Route path="settings/email" element={<EmailSettings />} />
         <Route path="settings/integrations" element={<Integrations />} />

         {/* Users Routes */}
        <Route path="users" element={<Users />} />
        <Route path="users/all" element={<AllUsers />} />
        <Route path="users/add" element={<AddUser />} />
        <Route path="users/roles" element={<UserRoles />} />
        <Route path="users/permissions" element={<Permissions />} />
        <Route path="users/active" element={<ActiveUsers />} />
        <Route path="users/blocked" element={<BlockedUsers />} />
        <Route path="users/reports" element={<UserReports />} />
          
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default AppRoutes;