document.addEventListener("DOMContentLoaded", () => {
  const uploadButton = document.getElementById("upload_widget");
  const imageUrlField = document.getElementById("image_url");
  const cloudName = uploadButton.dataset.cloud_name; // Retrieve cloud name from button data

  uploadButton.addEventListener("click", (e) => {
    e.preventDefault();
    cloudinary.openUploadWidget(
      { cloudName: cloudName, uploadPreset: "uw_test" },
      (error, result) => {
        if (!error && result && result.event === "success") {
          console.log("Image uploaded successfully:", result.info.secure_url);
          imageUrlField.value = result.info.secure_url; // Store the URL in the hidden field
        } else if (error) {
          console.error("Upload widget error:", error);
        }
      }
    );
  });
});