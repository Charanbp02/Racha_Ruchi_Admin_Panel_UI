import React, { useState } from "react";

function TotalVideos() {
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState("");

  const handleUploadVideo = () => {
    setNotificationMessage("Upload Video feature coming soon!");
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  return (
    <div className="min-h-screen">
      {/* Notification Toast */}
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-gray-800 text-white px-6 py-3 rounded-xl shadow-lg animate-bounce">
          {notificationMessage}
        </div>
      )}

      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">
          Total Videos
        </h2>
        <p className="text-gray-500">Manage and monitor all video content</p>
      </div>

      {/* Statistics Card */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm font-medium">Total Videos</p>
              <h2 className="text-4xl font-bold text-gray-800 mt-3">248</h2>
              <div className="flex items-center gap-2 mt-3">
                <span className="text-green-500 text-sm font-semibold">+12</span>
                <span className="text-gray-400 text-xs">this week</span>
              </div>
            </div>
            <div className="w-16 h-16 rounded-2xl bg-orange-100 flex items-center justify-center text-3xl font-bold">
              V
            </div>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm font-medium">Total Views</p>
              <h2 className="text-4xl font-bold text-gray-800 mt-3">125.8K</h2>
              <div className="flex items-center gap-2 mt-3">
                <span className="text-green-500 text-sm font-semibold">+2.4K</span>
                <span className="text-gray-400 text-xs">this week</span>
              </div>
            </div>
            <div className="w-16 h-16 rounded-2xl bg-blue-100 flex items-center justify-center text-3xl font-bold">
              V
            </div>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm font-medium">Avg. Watch Time</p>
              <h2 className="text-4xl font-bold text-gray-800 mt-3">4.2</h2>
              <div className="flex items-center gap-2 mt-3">
                <span className="text-green-500 text-sm font-semibold">min</span>
                <span className="text-gray-400 text-xs">per video</span>
              </div>
            </div>
            <div className="w-16 h-16 rounded-2xl bg-purple-100 flex items-center justify-center text-3xl font-bold">
              T
            </div>
          </div>
        </div>
      </div>

      {/* Video List */}
      <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-xl font-bold text-gray-800">Recent Videos</h3>
          <button 
            onClick={handleUploadVideo}
            className="bg-gradient-to-r from-orange-500 to-red-500 text-white px-4 py-2 rounded-xl text-sm font-medium hover:shadow-lg transition-all"
          >
            + Upload New Video
          </button>
        </div>

        <div className="space-y-4">
          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="flex items-center justify-between p-4 bg-gray-50 rounded-2xl hover:bg-gray-100 transition-all">
              <div className="flex items-center gap-4">
                <div className="w-24 h-16 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center text-white text-2xl font-bold">
                  V
                </div>
                <div>
                  <h4 className="font-medium text-gray-800">Chicken Biryani Recipe {i}</h4>
                  <p className="text-sm text-gray-500">Uploaded 2 days ago • 1.2K views</p>
                </div>
              </div>
              <div className="flex gap-2">
                <button className="px-3 py-1 text-sm bg-gray-200 rounded-lg hover:bg-gray-300">Edit</button>
                <button className="px-3 py-1 text-sm bg-red-100 text-red-600 rounded-lg hover:bg-red-200">Delete</button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default TotalVideos;