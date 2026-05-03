import React, { useState } from "react";

function PendingReviews() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterRating, setFilterRating] = useState("All");
  const [reviews, setReviews] = useState([
    { id: 1, product: "Racha Ruchi Masala", customer: "Rajesh Kumar", rating: 5, review: "Excellent product! Very authentic taste.", date: "2026-05-02", status: "Pending" },
    { id: 2, product: "Chicken Biryani Recipe", customer: "Priya Sharma", rating: 4, review: "Great recipe, easy to follow.", date: "2026-05-01", status: "Pending" },
    { id: 3, product: "Premium Cookware Set", customer: "Amit Singh", rating: 3, review: "Good quality but price is high.", date: "2026-05-01", status: "Pending" },
    { id: 4, product: "Organic Spices Box", customer: "Neha Gupta", rating: 5, review: "Fresh and aromatic spices!", date: "2026-04-30", status: "Pending" },
    { id: 5, product: "Pani Puri Kit", customer: "Vikram Mehta", rating: 4, review: "Tasty and easy to make.", date: "2026-04-29", status: "Pending" },
  ]);

  const handleApprove = (id) => {
    alert(`Review ${id} published`);
  };

  const handleReject = (id) => {
    alert(`Review ${id} rejected`);
  };

  const renderStars = (rating) => {
    return "★".repeat(rating) + "☆".repeat(5 - rating);
  };

  const filteredReviews = reviews.filter(review => {
    const matchesSearch = review.product.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          review.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          review.review.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRating = filterRating === "All" || review.rating === parseInt(filterRating);
    return matchesSearch && matchesRating;
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-red-50 to-amber-50">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-6 sm:mb-8">
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Pending Reviews</h2>
          <p className="text-sm sm:text-base text-gray-500">Customer reviews waiting for moderation</p>
        </div>

        {/* Filters */}
        <div className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 mb-6 shadow-md">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1">
              <input
                type="text"
                placeholder="Search by product, customer or review..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-4 py-2 sm:py-3 border border-gray-300 rounded-xl focus:outline-none focus:border-orange-500 text-sm sm:text-base"
              />
            </div>
            <select
              value={filterRating}
              onChange={(e) => setFilterRating(e.target.value)}
              className="px-4 py-2 sm:py-3 border border-gray-300 rounded-xl focus:outline-none focus:border-orange-500 text-sm sm:text-base"
            >
              <option value="All">All Ratings</option>
              <option value="5">5 Stars</option>
              <option value="4">4 Stars</option>
              <option value="3">3 Stars</option>
              <option value="2">2 Stars</option>
              <option value="1">1 Star</option>
            </select>
          </div>
        </div>

        {/* Reviews Grid */}
        <div className="grid grid-cols-1 gap-4 sm:gap-6">
          {filteredReviews.map(review => (
            <div key={review.id} className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-6 shadow-md hover:shadow-lg transition-all">
              <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4">
                <div className="flex-1">
                  <div className="flex flex-col sm:flex-row sm:items-center gap-2 mb-3">
                    <h3 className="font-bold text-gray-800 text-base sm:text-lg">{review.product}</h3>
                    <span className="text-yellow-500 text-sm sm:text-base">{renderStars(review.rating)}</span>
                  </div>
                  <p className="text-gray-600 text-sm sm:text-base mb-3">"{review.review}"</p>
                  <p className="text-xs sm:text-sm text-gray-500">By {review.customer} • {review.date}</p>
                </div>
                <div className="flex gap-3">
                  <button 
                    onClick={() => handleApprove(review.id)} 
                    className="flex-1 sm:flex-none px-4 py-2 bg-green-100 text-green-700 rounded-lg text-sm hover:bg-green-200 transition-all"
                  >
                    Approve
                  </button>
                  <button 
                    onClick={() => handleReject(review.id)} 
                    className="flex-1 sm:flex-none px-4 py-2 bg-red-100 text-red-700 rounded-lg text-sm hover:bg-red-200 transition-all"
                  >
                    Reject
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>

        {filteredReviews.length === 0 && (
          <div className="bg-white border border-gray-200 rounded-2xl p-8 sm:p-12 text-center">
            <div className="text-4xl sm:text-6xl mb-4">⭐</div>
            <h3 className="text-lg sm:text-xl font-semibold text-gray-800 mb-2">No pending reviews</h3>
            <p className="text-sm sm:text-base text-gray-500">All reviews have been moderated</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default PendingReviews;