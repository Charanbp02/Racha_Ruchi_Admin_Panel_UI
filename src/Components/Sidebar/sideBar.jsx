import React, { useState, useEffect } from "react";
import {
  HomeIcon,
  ShoppingCartIcon,
  ClockIcon,
  BookOpenIcon,
  Cog6ToothIcon,
  FilmIcon,
  UsersIcon,
  Bars3Icon,
  XMarkIcon,
  TagIcon,
  CubeIcon,
  ChevronDownIcon,
  ChevronRightIcon,
} from "@heroicons/react/24/outline";

import { Link, Outlet, useLocation } from "react-router-dom";

const SideBar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isMobile, setIsMobile] = useState(false);
  const [openSubMenus, setOpenSubMenus] = useState({});

  const location = useLocation();

  useEffect(() => {
    const checkScreenSize = () => {
      setIsMobile(window.innerWidth < 1024);

      if (window.innerWidth >= 1024) {
        setIsOpen(true);
      } else {
        setIsOpen(false);
      }
    };

    checkScreenSize();

    window.addEventListener("resize", checkScreenSize);

    return () => window.removeEventListener("resize", checkScreenSize);
  }, []);

  // Auto-expand submenu when a sub-item is active
  useEffect(() => {
    menuItems.forEach((item) => {
      if (item.subItems?.some(sub => location.pathname === sub.path)) {
        setOpenSubMenus(prev => ({
          ...prev,
          [item.name]: true
        }));
      }
    });
  }, [location.pathname]);

  const toggleSubMenu = (menuName) => {
    setOpenSubMenus(prev => ({
      ...prev,
      [menuName]: !prev[menuName]
    }));
  };

  const menuItems = [
    { 
      name: "Dashboard", 
      icon: HomeIcon, 
      path: "/",
      subItems: [
        { name: "Total Videos", path: "/total-videos" },
        { name: "Pending Approvals", path: "/pending-approvals" },
        { name: "Total Users", path: "/total-users" },
        { name: "Total Products", path: "/total-products" },
        { name: "Recent Activity", path: "/recent-activity" },
      ]
    },
    { 
      name: "Category", 
      icon: TagIcon, 
      path: "/category",
      subItems: [
        { name: "Add Category", path: "/category/add" },
        { name: "Manage Categories", path: "/category/manage" },
        { name: "Sub Categories", path: "/category/sub" },
        { name: "Category Settings", path: "/category/settings" },
      ]
    },
    { 
      name: "Orders", 
      icon: ShoppingCartIcon, 
      path: "/orders",
      subItems: [
        { name: "All Orders", path: "/orders/all" },
        { name: "New Orders", path: "/orders/new" },
        { name: "Processing", path: "/orders/processing" },
        { name: "Completed", path: "/orders/completed" },
        { name: "Cancelled", path: "/orders/cancelled" },
        { name: "Returns", path: "/orders/returns" },
      ]
    },
    { 
      name: "Pending", 
      icon: ClockIcon, 
      path: "/pending",
      subItems: [
        { name: "Pending Orders", path: "/pending/orders" },
        { name: "Pending Payments", path: "/pending/payments" },
        { name: "Pending Approval", path: "/pending/approval" },
        { name: "Pending Reviews", path: "/pending/reviews" },
      ]
    },
    { 
      name: "Products", 
      icon: CubeIcon, 
      path: "/products",
      subItems: [
        { name: "All Products", path: "/products/all" },
        { name: "Add Product", path: "/products/add" },
        { name: "Edit Products", path: "/products/edit" },
        { name: "Product Stock", path: "/products/stock" },
        { name: "Product Categories", path: "/products/categories" },
        { name: "Product Tags", path: "/products/tags" },
        { name: "Product Reviews", path: "/products/reviews" },
      ]
    },
    { 
      name: "Videos", 
      icon: FilmIcon, 
      path: "/videos",
      subItems: [
        { name: "All Videos", path: "/videos/all" },
        { name: "Upload Video", path: "/videos/upload" },
        { name: "Video Categories", path: "/videos/categories" },
        { name: "Popular Videos", path: "/videos/popular" },
        { name: "Video Requests", path: "/videos/requests" },
      ]
    },
    { 
      name: "Shorts", 
      icon: FilmIcon, 
      path: "/shorts",
      subItems: [
        { name: "All Shorts", path: "/shorts/all" },
        { name: "Upload Short", path: "/shorts/upload" },
        { name: "Trending Shorts", path: "/shorts/trending" },
        { name: "Short Categories", path: "/shorts/categories" },
      ]
    },
    { 
      name: "Settings", 
      icon: Cog6ToothIcon, 
      path: "/settings",
      subItems: [
        { name: "General Settings", path: "/settings/general" },
        { name: "Profile Settings", path: "/settings/profile" },
        { name: "Security", path: "/settings/security" },
        { name: "Notifications", path: "/settings/notifications" },
        { name: "Payment Settings", path: "/settings/payment" },
        { name: "Email Settings", path: "/settings/email" },
        { name: "Integrations", path: "/settings/integrations" },
      ]
    },
    { 
      name: "Users", 
      icon: UsersIcon, 
      path: "/users",
      subItems: [
        { name: "All Users", path: "/users/all" },
        { name: "Add User", path: "/users/add" },
        { name: "User Roles", path: "/users/roles" },
        { name: "Permissions", path: "/users/permissions" },
        { name: "Active Users", path: "/users/active" },
        { name: "Blocked Users", path: "/users/blocked" },
        { name: "User Reports", path: "/users/reports" },
      ]
    },
  ];

  const toggleSidebar = () => {
    setIsOpen(!isOpen);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-purple-50 to-pink-50">

      {/* Mobile Menu Button */}
      <button
        onClick={toggleSidebar}
        className="lg:hidden fixed top-4 left-4 z-50 p-3 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl shadow-lg"
      >
        {isOpen ? (
          <XMarkIcon className="h-6 w-6 text-white" />
        ) : (
          <Bars3Icon className="h-6 w-6 text-white" />
        )}
      </button>

      {/* Mobile Overlay */}
      {isOpen && isMobile && (
        <div
          className="fixed inset-0 bg-black/50 z-40"
          onClick={toggleSidebar}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
          fixed top-0 left-0 h-full z-50
          bg-gradient-to-b from-purple-900 via-purple-800 to-pink-900
          text-white shadow-2xl
          transition-all duration-300 ease-in-out
          overflow-y-auto
          ${isOpen ? "w-72" : "w-20"}
          ${isOpen ? "translate-x-0" : "-translate-x-full"}
          lg:translate-x-0
          ${isOpen ? "lg:w-72" : "lg:w-20"}
        `}
      >

        {/* Logo */}
        <div className="flex items-center justify-between p-5 border-b border-purple-700/50 sticky top-0 bg-purple-900/95 z-10">

          {isOpen ? (
            <div className="flex items-center gap-3">

              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-400 to-pink-500 flex items-center justify-center">
                <span className="text-white font-bold text-xl">
                  RC
                </span>
              </div>

              <div>
                <h1 className="font-bold text-xl">
                  RACHA RUCHI
                </h1>

                <p className="text-xs text-purple-300">
                  Admin Panel
                </p>
              </div>

            </div>
          ) : (
            <div className="w-full flex justify-center">

              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-400 to-pink-500 flex items-center justify-center">
                <span className="text-white font-bold text-xl">
                  र
                </span>
              </div>

            </div>
          )}

          {/* Desktop Toggle */}
          <button
            onClick={toggleSidebar}
            className="hidden lg:flex p-2 rounded-lg hover:bg-white/10"
          >
            {isOpen ? (
              <XMarkIcon className="h-5 w-5" />
            ) : (
              <Bars3Icon className="h-5 w-5" />
            )}
          </button>

        </div>

        {/* Navigation */}
        <nav className="mt-4 px-3 pb-20">

          {menuItems.map((item) => {

            const IconComponent = item.icon;
            const isActive = location.pathname === item.path || 
                            item.subItems?.some(sub => location.pathname === sub.path);
            const isSubMenuOpen = openSubMenus[item.name];

            return (
              <div key={item.name} className="mb-2">
                <div className="relative">
                  <Link
                    to={item.path}
                    onClick={(e) => {
                      if (item.subItems && item.subItems.length > 0) {
                        e.preventDefault();
                        toggleSubMenu(item.name);
                      } else if (isMobile) {
                        setIsOpen(false);
                      }
                    }}
                    className={`
                      w-full flex items-center gap-3 px-4 py-3 rounded-xl
                      transition-all duration-300 group relative
                      cursor-pointer
                      ${
                        isActive
                          ? "bg-gradient-to-r from-purple-500 to-pink-500 text-white shadow-lg"
                          : "text-purple-100 hover:bg-white/10 hover:text-white"
                      }
                      ${!isOpen && "justify-center"}
                    `}
                  >

                    <IconComponent
                      className={`
                        h-5 w-5 flex-shrink-0
                        ${
                          isActive
                            ? "text-white"
                            : "text-purple-300 group-hover:text-white"
                        }
                      `}
                    />

                    {isOpen && (
                      <span className="text-sm font-medium flex-1 text-left">
                        {item.name}
                      </span>
                    )}

                    {isOpen && item.subItems && item.subItems.length > 0 && (
                      <span className="p-1">
                        {isSubMenuOpen ? (
                          <ChevronDownIcon className="h-4 w-4" />
                        ) : (
                          <ChevronRightIcon className="h-4 w-4" />
                        )}
                      </span>
                    )}

                    {/* Tooltip */}
                    {!isOpen && (
                      <div className="absolute left-full ml-3 px-3 py-1.5 bg-gray-900 text-white text-sm rounded-lg opacity-0 group-hover:opacity-100 whitespace-nowrap z-50 pointer-events-none">
                        {item.name}
                      </div>
                    )}

                  </Link>
                </div>

                {/* Sub Items */}
                {isOpen && isSubMenuOpen && item.subItems && (
                  <div className="ml-6 mt-1 space-y-1 border-l-2 border-purple-600/50 pl-3">
                    {item.subItems.map((subItem) => (
                      <Link
                        key={subItem.path}
                        to={subItem.path}
                        onClick={() => {
                          if (isMobile) setIsOpen(false);
                        }}
                        className={`
                          flex items-center gap-3 px-4 py-2 rounded-lg text-sm
                          transition-all duration-200
                          ${location.pathname === subItem.path
                            ? "bg-purple-600/30 text-purple-200"
                            : "text-purple-300 hover:bg-white/10 hover:text-white"
                          }
                        `}
                      >
                        <div className="w-1.5 h-1.5 rounded-full bg-purple-400"></div>
                        <span>{subItem.name}</span>
                      </Link>
                    ))}
                  </div>
                )}
              </div>
            );
          })}

        </nav>

      </aside>

      {/* Main Content */}
      <main
        className={`
          transition-all duration-300 ease-in-out min-h-screen
          ${isOpen ? "lg:pl-72" : "lg:pl-20"}
        `}
      >

        <div className="p-4 md:p-6 lg:p-8">

          {/* Header */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl shadow-lg p-5 mb-6 border border-purple-100">

            <div className="flex flex-col md:flex-row md:items-center md:justify-between">

              <div>

                <h1 className="text-3xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                  RACHA RUCHI
                </h1>

                <p className="text-gray-600 mt-1">
                  Welcome back to Admin Panel
                </p>

              </div>

              <div className="mt-4 md:mt-0 text-sm text-gray-500">

                {new Date().toLocaleDateString("en-US", {
                  weekday: "long",
                  year: "numeric",
                  month: "long",
                  day: "numeric",
                })}

              </div>

            </div>

          </div>

          {/* Dynamic Pages */}
          <Outlet />

        </div>

      </main>

    </div>
  );
};

export default SideBar;