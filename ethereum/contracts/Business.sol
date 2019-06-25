pragma solidity ^0.4.17;

// BusinessFactory : deployed once
contract BusinessFactory {
    // deployedBusinesses : holds list of all businesses created.
    address[] public deployedBusinesses;
    // existingBusinesses : holds address & bool value of businesses created to prevent duplicates.
    mapping(address => bool) public existingBusinesses;
    
    // createBusiness : called when business owners create a business page for themselves
    function createBusiness(string businessName, string businessOwnerName, string businessWebsite) public duplicateBusiness{
        address newBusiness = new Business(businessName, businessOwnerName, businessWebsite, msg.sender);
        deployedBusinesses.push(newBusiness);
        existingBusinesses[msg.sender] = true;
    }
    
    // getDeployedBusinesses : helper func returns address[] of all deployed Business contracts
    function getDeployedBusinesses() public view returns (address[]){
        return deployedBusinesses;
    }
    
    modifier duplicateBusiness () {
        require(!existingBusinesses[msg.sender]);
        _;
    }
}

// Business contract : deployed each time a new business owner wants create a new page for their business
contract Business {
    
    string public Name;
    string public OwnerName;
    string public Website;
    address public OwnerAddress;
    uint public totalReviewsCount;
    uint public totalReviewScore;
    address[] public deployedReviews;
    mapping(address => bool) public existingReviews;
    
    // Business : constructor 
    function Business(string businessName, string businessOwnerName,string businessWebsite, address businessOwnerAddress) public {
        Name = businessName;
        OwnerName = businessOwnerName;
        Website = businessWebsite;
        OwnerAddress = businessOwnerAddress;
    }
    
    // createReview : used by Reviewers to deploy a new Review for this particular business
    function createReview(string review, uint reviewScore) public duplicateReview notOwner{
        require(reviewScore > 0 && reviewScore < 6);
        address newReview = new Review(review, reviewScore, msg.sender);
        deployedReviews.push(newReview);
        totalReviewsCount++;
        totalReviewScore += reviewScore;
        existingReviews[msg.sender] = true;
    }
    
    // getDeployedReviews : helper func returns address[] of all Reviews left for this business
    function getDeployedReviews() public view returns (address[]) {
        return deployedReviews;
    }
    
    modifier duplicateReview () {
        require(!existingReviews[msg.sender]);
        _;
    }
    
    modifier notOwner () {
        require(msg.sender != OwnerAddress);
        _;
    }
    
}

// Review contract : deployed each time a new Reviewer leaves a Review for a particular Business.
contract Review {
    address public reviewOwner;
    string public review;
    uint public reviewScore;
    
    // Review constructor
    function Review(string businessReview, uint businessReviewScore, address businessReviewOwner) public {
        review = businessReview;
        reviewScore = businessReviewScore;
        reviewOwner = businessReviewOwner;
    }
}