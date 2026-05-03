// Navbar.jsx
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import * as Iconsax from 'iconsax-react';

const Navbar = ({ sidebarOpen, setSidebarOpen }) => {
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [notificationsOpen, setNotificationsOpen] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const [isMobile, setIsMobile] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth < 768);
    };
    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const notifications = [
    { id: 1, title: 'New order received', time: '5 min ago', read: false, link: '/orders' },
    { id: 2, title: 'Pending orders waiting', time: '1 hour ago', read: false, link: '/pending' },
    { id: 3, title: 'New user registered', time: '3 hours ago', read: true, link: '/users' },
  ];

  const toggleDarkMode = () => {
    setDarkMode(!darkMode);
    document.documentElement.classList.toggle('dark');
  };

  // Safe icon renderer with fallback
  const renderIcon = (IconComponent, size = "20", variant = "Outline", className = "") => {
    if (!IconComponent) {
      return <Iconsax.Element size={size} variant={variant} className={className} />;
    }
    return <IconComponent size={size} variant={variant} className={className} />;
  };

  return (
    <nav className="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700 fixed top-0 right-0 left-0 z-30 transition-colors duration-200">
      <div className="px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Left Section */}
          <div className="flex items-center gap-2 sm:gap-4">
            <button
              onClick={() => setSidebarOpen(!sidebarOpen)}
              className="p-2 rounded-lg text-gray-500 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-orange-500 transition-all duration-200 hover:scale-105"
              aria-label="Toggle menu"
            >
              {renderIcon(Iconsax.Menu1, "20", "Outline")}
            </button>

            <div className="flex items-center gap-2">
              <div className="bg-gradient-to-r from-orange-500 to-orange-600 p-1.5 rounded-lg shadow-md">
                {renderIcon(Iconsax.Crown, "20", "Bold", "text-white")}
              </div>
              {!isMobile && (
                <span className="text-lg sm:text-xl font-bold bg-gradient-to-r from-orange-600 to-orange-500 bg-clip-text text-transparent">
                  RACHA RUCHI
                </span>
              )}
            </div>

            {/* Search Bar - Desktop */}
            <div className="hidden md:flex items-center ml-4 lg:ml-6">
              <div className="relative">
                {renderIcon(Iconsax.SearchNormal1, "18", "Outline", "absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400")}
                <input
                  type="text"
                  placeholder="Search menu, orders, customers..."
                  className="pl-10 pr-4 py-2 w-64 lg:w-80 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all"
                />
              </div>
            </div>
          </div>

          {/* Right Section */}
          <div className="flex items-center gap-1 sm:gap-2">
            <button
              onClick={toggleDarkMode}
              className="p-2 rounded-lg text-gray-500 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800 transition-all duration-200 hover:scale-105"
              aria-label="Toggle dark mode"
            >
              {darkMode ? 
                renderIcon(Iconsax.Sun1, "20", "Bold") : 
                renderIcon(Iconsax.Moon, "20", "Outline")
              }
            </button>

            {/* Notifications */}
            <div className="relative">
              <button
                onClick={() => setNotificationsOpen(!notificationsOpen)}
                className="p-2 rounded-lg text-gray-500 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800 relative transition-all duration-200 hover:scale-105"
                aria-label="Notifications"
              >
                {renderIcon(Iconsax.Notification, "20", "Outline")}
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full animate-pulse"></span>
              </button>

              {notificationsOpen && (
                <div className="absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 z-50 animate-fadeIn">
                  <div className="p-3 border-b border-gray-200 dark:border-gray-700">
                    <h3 className="font-semibold text-gray-900 dark:text-white">Notifications</h3>
                  </div>
                  <div className="max-h-96 overflow-y-auto">
                    {notifications.map((notif) => (
                      <div
                        key={notif.id}
                        className={`p-3 border-b border-gray-100 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 cursor-pointer transition-all duration-200 ${
                          !notif.read ? 'bg-orange-50 dark:bg-orange-900/20' : ''
                        }`}
                        onClick={() => {
                          navigate(notif.link);
                          setNotificationsOpen(false);
                        }}
                      >
                        <p className="text-sm text-gray-900 dark:text-white font-medium">{notif.title}</p>
                        <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">{notif.time}</p>
                      </div>
                    ))}
                  </div>
                  <div className="p-2 text-center border-t border-gray-200 dark:border-gray-700">
                    <button className="text-sm text-orange-600 dark:text-orange-400 hover:text-orange-700 font-medium">
                      View all notifications
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* User Dropdown */}
            <div className="relative">
              <button
                onClick={() => setUserDropdownOpen(!userDropdownOpen)}
                className="flex items-center gap-2 p-1.5 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 hover:scale-105"
                aria-label="User menu"
              >
                <div className="w-8 h-8 rounded-full bg-gradient-to-r from-orange-500 to-orange-600 flex items-center justify-center shadow-md">
                  {renderIcon(Iconsax.Profile, "16", "Bold", "text-white")}
                </div>
                {!isMobile && (
                  <>
                    <div className="hidden lg:block text-left">
                      <p className="text-sm font-medium text-gray-900 dark:text-white">Admin User</p>
                      <p className="text-xs text-gray-500 dark:text-gray-400">Restaurant Owner</p>
                    </div>
                    {renderIcon(Iconsax.ArrowDown2, "14", "Outline", "text-gray-500 dark:text-gray-400 hidden lg:block")}
                  </>
                )}
              </button>

              {userDropdownOpen && (
                <div className="absolute right-0 mt-2 w-56 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 z-50 animate-fadeIn">
                  <div className="p-3 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900">
                    <p className="text-sm font-medium text-gray-900 dark:text-white">Admin User</p>
                    <p className="text-xs text-gray-500 dark:text-gray-400">admin@racharuchi.com</p>
                  </div>
                  <div className="py-1">
                    <button className="w-full text-left px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center gap-2 transition-colors">
                      {renderIcon(Iconsax.Profile, "16", "Outline")} Profile
                    </button>
                    <button 
                      onClick={() => {
                        navigate('/settings');
                        setUserDropdownOpen(false);
                      }}
                      className="w-full text-left px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center gap-2 transition-colors"
                    >
                      {renderIcon(Iconsax.Setting2, "16", "Outline")} Settings
                    </button>
                    <button className="w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center gap-2 transition-colors">
                      {renderIcon(Iconsax.Logout, "16", "Outline")} Logout
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Mobile Search Bar */}
        {isMobile && (
          <div className="pb-3">
            <div className="relative">
              {renderIcon(Iconsax.SearchNormal1, "18", "Outline", "absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400")}
              <input
                type="text"
                placeholder="Search..."
                className="pl-10 pr-4 py-2 w-full rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              />
            </div>
          </div>
        )}
      </div>

      {/* Click outside to close dropdowns */}
      {(userDropdownOpen || notificationsOpen) && (
        <div
          className="fixed inset-0 z-40"
          onClick={() => {
            setUserDropdownOpen(false);
            setNotificationsOpen(false);
          }}
        />
      )}

      <style>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(-10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        .animate-fadeIn {
          animation: fadeIn 0.2s ease-out;
        }
      `}</style>
    </nav>
  );
};

export default Navbar;