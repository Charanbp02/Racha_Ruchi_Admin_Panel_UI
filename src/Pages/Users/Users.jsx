import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Users as UsersIcon, UserPlus, Shield, Lock, UserCheck, UserX, FileText, TrendingUp } from "lucide-react";

function Users() {
  const navigate = useNavigate();

  const stats = {
    totalUsers: 12500,
    activeUsers: 10200,
    blockedUsers: 345,
    newUsers: 240,
    admins: 12,
    chefs: 48
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                User Management
              </h1>
              <p className="text-gray-500 mt-2">Manage users, roles, permissions and reports</p>
            </div>
            <button 
              onClick={() => navigate("/users/add")}
              className="px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
            >
              <UserPlus className="w-5 h-5" />
              Add New User
            </button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-6 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Total Users</p>
                <p className="text-2xl font-bold text-gray-800">{stats.totalUsers.toLocaleString()}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                <UsersIcon className="w-5 h-5 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Active Users</p>
                <p className="text-2xl font-bold text-green-600">{stats.activeUsers.toLocaleString()}</p>
              </div>
              <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
                <UserCheck className="w-5 h-5 text-green-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Blocked Users</p>
                <p className="text-2xl font-bold text-red-600">{stats.blockedUsers}</p>
              </div>
              <div className="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center">
                <UserX className="w-5 h-5 text-red-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">New This Month</p>
                <p className="text-2xl font-bold text-orange-600">{stats.newUsers}</p>
              </div>
              <div className="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-orange-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Admins</p>
                <p className="text-2xl font-bold text-purple-600">{stats.admins}</p>
              </div>
              <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                <Shield className="w-5 h-5 text-purple-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Chefs</p>
                <p className="text-2xl font-bold text-cyan-600">{stats.chefs}</p>
              </div>
              <div className="w-10 h-10 bg-cyan-100 rounded-xl flex items-center justify-center">
                <UsersIcon className="w-5 h-5 text-cyan-600" />
              </div>
            </div>
          </div>
        </div>

        {/* Quick Navigation Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/all")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                <UsersIcon className="w-6 h-6 text-blue-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">All Users</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">View and manage all registered users</p>
            <button className="w-full py-2 bg-blue-100 text-blue-700 rounded-xl font-medium hover:bg-blue-200 transition-all">
              View All Users
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/add")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                <UserPlus className="w-6 h-6 text-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Add User</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Add new users to the system</p>
            <button className="w-full py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all">
              Add New User
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/roles")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                <Shield className="w-6 h-6 text-purple-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">User Roles</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Manage user roles and permissions</p>
            <button className="w-full py-2 bg-purple-100 text-purple-700 rounded-xl font-medium hover:bg-purple-200 transition-all">
              Manage Roles
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/permissions")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                <Lock className="w-6 h-6 text-yellow-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Permissions</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Set user access permissions</p>
            <button className="w-full py-2 bg-yellow-100 text-yellow-700 rounded-xl font-medium hover:bg-yellow-200 transition-all">
              Set Permissions
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/active")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                <UserCheck className="w-6 h-6 text-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Active Users</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">View all active users</p>
            <button className="w-full py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all">
              View Active Users
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/blocked")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                <UserX className="w-6 h-6 text-red-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Blocked Users</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">View and manage blocked users</p>
            <button className="w-full py-2 bg-red-100 text-red-700 rounded-xl font-medium hover:bg-red-200 transition-all">
              View Blocked Users
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer" onClick={() => navigate("/users/reports")}>
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                <FileText className="w-6 h-6 text-orange-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">User Reports</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Generate user activity reports</p>
            <button className="w-full py-2 bg-orange-100 text-orange-700 rounded-xl font-medium hover:bg-orange-200 transition-all">
              View Reports
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Users;