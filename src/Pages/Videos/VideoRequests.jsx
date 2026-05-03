import React, { useState } from "react";
import { Search, CheckCircle, XCircle, Clock, User, Video, Play } from "lucide-react";

function VideoRequests() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterStatus, setFilterStatus] = useState("all");
  const [requests, setRequests] = useState([
    { id: 1, title: "Vegan Pizza Recipe Video", requestedBy: "Priya Sharma", date: "2026-05-02", status: "Pending", priority: "High", description: "Looking for a healthy vegan pizza recipe video" },
    { id: 2, title: "Keto Desserts Tutorial", requestedBy: "Rajesh Kumar", date: "2026-05-01", status: "Pending", priority: "Medium", description: "Low carb dessert options video" },
    { id: 3, title: "Traditional South Indian Cooking", requestedBy: "Neha Gupta", date: "2026-04-30", status: "In Progress", priority: "High", description: "Authentic South Indian recipes video series" },
    { id: 4, title: "Quick Breakfast Ideas", requestedBy: "Amit Singh", date: "2026-04-29", status: "Completed", priority: "Low", description: "5-minute breakfast recipes video" },
  ]);

  const handleApprove = (id) => {
    setRequests(requests.map(req => 
      req.id === id ? { ...req, status: "In Progress" } : req
    ));
  };

  const handleReject = (id) => {
    setRequests(requests.filter(req => req.id !== id));
  };

  const getStatusBadge = (status) => {
    const colors = {
      Pending: "bg-yellow-100 text-yellow-700",
      "In Progress": "bg-blue-100 text-blue-700",
      Completed: "bg-green-100 text-green-700"
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[status]}`}>{status}</span>;
  };

  const getPriorityBadge = (priority) => {
    const colors = {
      High: "bg-red-100 text-red-700",
      Medium: "bg-orange-100 text-orange-700",
      Low: "bg-green-100 text-green-700"
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[priority]}`}>{priority}</span>;
  };

  const filteredRequests = requests.filter(req => {
    const matchesSearch = req.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          req.requestedBy.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === "all" || req.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
            Video Requests
          </h1>
          <p className="text-gray-500 mt-2">Manage customer video requests</p>
        </div>

        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search requests..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500"
              />
            </div>
            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 bg-white"
            >
              <option value="all">All Status</option>
              <option value="Pending">Pending</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
            </select>
          </div>
        </div>

        <div className="space-y-4">
          {filteredRequests.map(request => (
            <div key={request.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
              <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2 flex-wrap">
                    <h3 className="font-bold text-gray-800 text-lg">{request.title}</h3>
                    {getPriorityBadge(request.priority)}
                    {getStatusBadge(request.status)}
                  </div>
                  <p className="text-gray-600 mb-3">{request.description}</p>
                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span className="flex items-center gap-1">
                      <User className="w-4 h-4" />
                      {request.requestedBy}
                    </span>
                    <span className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      {request.date}
                    </span>
                  </div>
                </div>
                {request.status === "Pending" && (
                  <div className="flex gap-3">
                    <button 
                      onClick={() => handleApprove(request.id)}
                      className="px-4 py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all flex items-center gap-2"
                    >
                      <CheckCircle className="w-4 h-4" />
                      Accept
                    </button>
                    <button 
                      onClick={() => handleReject(request.id)}
                      className="px-4 py-2 bg-red-100 text-red-700 rounded-xl font-medium hover:bg-red-200 transition-all flex items-center gap-2"
                    >
                      <XCircle className="w-4 h-4" />
                      Reject
                    </button>
                  </div>
                )}
                {request.status === "In Progress" && (
                  <button className="px-4 py-2 bg-purple-100 text-purple-700 rounded-xl font-medium flex items-center gap-2">
                    <Video className="w-4 h-4" />
                    Upload Video
                  </button>
                )}
                {request.status === "Completed" && (
                  <span className="px-4 py-2 bg-green-100 text-green-700 rounded-xl font-medium flex items-center gap-2">
                    <CheckCircle className="w-4 h-4" />
                    Completed
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>

        {filteredRequests.length === 0 && (
          <div className="bg-white rounded-2xl p-12 text-center">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Video className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No requests found</h3>
            <p className="text-gray-500">No video requests matching your criteria</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default VideoRequests;