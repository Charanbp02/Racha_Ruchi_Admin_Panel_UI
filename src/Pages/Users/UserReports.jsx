import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { FileText, Download, Calendar, Users, TrendingUp, Activity, Eye } from "lucide-react";

function UserReports() {
  const navigate = useNavigate();
  const [dateRange, setDateRange] = useState({ start: "", end: "" });

  const reports = [
    { id: 1, title: "User Registration Report", description: "Daily new user registrations", type: "Registration", lastGenerated: "2026-05-02" },
    { id: 2, title: "User Activity Report", description: "User login and activity summary", type: "Activity", lastGenerated: "2026-05-02" },
    { id: 3, title: "Role Distribution Report", description: "Users grouped by roles", type: "Distribution", lastGenerated: "2026-05-01" },
    { id: 4, title: "User Engagement Report", description: "User interaction and engagement metrics", type: "Engagement", lastGenerated: "2026-05-01" },
  ];

  const stats = {
    totalUsers: 12500,
    newUsers: 240,
    activeUsers: 10200,
    deletedUsers: 128
  };

  const handleGenerateReport = (report) => {
    alert(`Generating ${report.title}...`);
  };

  const handleDownload = () => {
    alert("Downloading report...");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            User Reports
          </h1>
          <p className="text-gray-500 mt-2">Generate and download user activity reports</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Total Users</p>
                <p className="text-2xl font-bold text-gray-800">{stats.totalUsers.toLocaleString()}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                <Users className="w-5 h-5 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">New Users (Month)</p>
                <p className="text-2xl font-bold text-green-600">{stats.newUsers}</p>
              </div>
              <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-green-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Active Users</p>
                <p className="text-2xl font-bold text-purple-600">{stats.activeUsers.toLocaleString()}</p>
              </div>
              <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                <Activity className="w-5 h-5 text-purple-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Deleted Users</p>
                <p className="text-2xl font-bold text-red-600">{stats.deletedUsers}</p>
              </div>
              <div className="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center">
                <FileText className="w-5 h-5 text-red-600" />
              </div>
            </div>
          </div>
        </div>

        {/* Date Range Filter */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4 items-end">
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-2">Start Date</label>
              <input
                type="date"
                value={dateRange.start}
                onChange={(e) => setDateRange({ ...dateRange, start: e.target.value })}
                className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-2">End Date</label>
              <input
                type="date"
                value={dateRange.end}
                onChange={(e) => setDateRange({ ...dateRange, end: e.target.value })}
                className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <button className="px-6 py-3 bg-blue-600 text-white rounded-xl font-medium hover:bg-blue-700 transition-all">
              Apply Filter
            </button>
          </div>
        </div>

        {/* Reports Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {reports.map(report => (
            <div key={report.id} className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                    <FileText className="w-6 h-6 text-blue-600" />
                  </div>
                  <div>
                    <h3 className="text-lg font-bold text-gray-800">{report.title}</h3>
                    <p className="text-sm text-gray-500 mt-1">{report.description}</p>
                  </div>
                </div>
                <span className="px-2 py-1 bg-gray-100 text-gray-600 rounded-full text-xs">
                  {report.type}
                </span>
              </div>
              <div className="flex items-center justify-between pt-4 border-t border-gray-100">
                <p className="text-xs text-gray-400">Last generated: {report.lastGenerated}</p>
                <div className="flex gap-2">
                  <button 
                    onClick={() => handleGenerateReport(report)}
                    className="px-4 py-2 bg-green-100 text-green-700 rounded-lg text-sm font-medium hover:bg-green-200 transition-all flex items-center gap-1"
                  >
                    <Eye className="w-4 h-4" />
                    Generate
                  </button>
                  <button 
                    onClick={handleDownload}
                    className="px-4 py-2 bg-purple-100 text-purple-700 rounded-lg text-sm font-medium hover:bg-purple-200 transition-all flex items-center gap-1"
                  >
                    <Download className="w-4 h-4" />
                    Download
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Quick Export */}
        <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-6">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
              <h3 className="text-lg font-bold text-gray-800">Export All User Data</h3>
              <p className="text-sm text-gray-500 mt-1">Export complete user database to CSV/Excel</p>
            </div>
            <div className="flex gap-3">
              <button className="px-5 py-2 bg-white text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-all flex items-center gap-2">
                <Download className="w-4 h-4" />
                Export as CSV
              </button>
              <button className="px-5 py-2 bg-white text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-all flex items-center gap-2">
                <Download className="w-4 h-4" />
                Export as Excel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default UserReports;