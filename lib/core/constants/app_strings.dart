class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Bookify';
  static const String appTagline = 'ອ່ານ ຂຽນ ແບ່ງປັນເລື່ອງລາວຂອງທ່ານ';

  // Auth
  static const String login = 'ເຂົ້າສູ່ລະບົບ';
  static const String register = 'ສະໝັກສະມາຊິກ';
  static const String email = 'ອີເມລ';
  static const String password = 'ລະຫັດຜ່ານ';
  static const String confirmPassword = 'ຢືນຢັນລະຫັດຜ່ານ';
  static const String forgotPassword = 'ລືມລະຫັດຜ່ານ?';
  static const String alreadyHaveAccount = 'ມີບັນຊີແລ້ວ?';
  static const String dontHaveAccount = "ຍັງບໍ່ມີບັນຊີ?";
  static const String signIn = 'ເຂົ້າສູ່ລະບົບ';
  static const String signUp = 'ສະໝັກສະມາຊິກ';
  static const String signOut = 'ອອກຈາກລະບົບ';
  static const String fullName = 'ຊື່-ນາມສະກຸນ';
  static const String username = 'ຊື່ຜູ້ໃຊ້';

  // Home
  static const String home = 'ໜ້າຫຼັກ';
  static const String myLibrary = 'ຄັງຂອງຂ້ອຍ';
  static const String discover = 'ຄົ້ນຫາ';
  static const String write = 'ຂຽນ';
  static const String profile = 'ໂປຣໄຟລ໌';

  // Books
  static const String books = 'ປຶ້ມ';
  static const String myBooks = 'ປຶ້ມຂອງຂ້ອຍ';
  static const String createBook = 'ສ້າງປຶ້ມ';
  static const String bookTitle = 'ຊື່ປຶ້ມ';
  static const String bookDescription = 'ຄຳອະທິບາຍ';
  static const String bookGenre = 'ໝວດໝູ່';
  static const String bookCover = 'ປົກປຶ້ມ';
  static const String publishBook = 'ເຜີຍແຜ່ປຶ້ມ';
  static const String saveDraft = 'ບັນທຶກສະບັບຮ່າງ';
  static const String continueReading = 'ອ່ານຕໍ່';
  static const String startReading = 'ເລີ່ມອ່ານ';

  // Chapters
  static const String chapters = 'ບົດ';
  static const String chapterTitle = 'ຊື່ບົດ';
  static const String chapterContent = 'ເນື້ອຫາບົດ';
  static const String addChapter = 'ເພີ່ມບົດ';
  static const String editChapter = 'ແກ້ໄຂບົດ';
  static const String deleteChapter = 'ລຶບບົດ';
  static const String publishChapter = 'ເຜີຍແຜ່ບົດ';

  // Writing
  static const String startWriting = 'ເລີ່ມຂຽນ';
  static const String writeYourStory = 'ຂຽນເລື່ອງລາວຂອງທ່ານ...';
  static const String wordCount = 'ຈຳນວນຄຳ';
  static const String saveProgress = 'ບັນທຶກຄວາມຄືບໜ້າ';
  static const String autoSaved = 'ບັນທຶກອັດຕະໂນມັດ';

  // Profile
  static const String editProfile = 'ແກ້ໄຂໂປຣໄຟລ໌';
  static const String followers = 'ຜູ້ຕິດຕາມ';
  static const String following = 'ກຳລັງຕິດຕາມ';
  static const String bio = 'ແນະນຳຕົວ';
  static const String website = 'ເວັບໄຊ';
  static const String changePhoto = 'ປ່ຽນຮູບ';

  // Settings
  static const String settings = 'ຕັ້ງຄ່າ';
  static const String notifications = 'ການແຈ້ງເຕືອນ';
  static const String privacy = 'ຄວາມເປັນສ່ວນຕົວ';
  static const String help = 'ຊ່ວຍເຫຼືອ';
  static const String about = 'ກ່ຽວກັບ';
  static const String termsOfService = 'ເງື່ອນໄຂການໃຊ້ງານ';
  static const String privacyPolicy = 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ';

  // Errors
  static const String somethingWentWrong = 'ເກີດຂໍ້ຜິດພາດ';
  static const String noInternetConnection = 'ບໍ່ມີການເຊື່ອມຕໍ່ອິນເຕີເນັດ';
  static const String invalidEmail = 'ອີເມລບໍ່ຖືກຕ້ອງ';
  static const String weakPassword = 'ລະຫັດຜ່ານຕ້ອງມີຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ';
  static const String passwordsDoNotMatch = 'ລະຫັດຜ່ານບໍ່ຕົງກັນ';
  static const String emailAlreadyInUse = 'ອີເມລນີ້ຖືກໃຊ້ແລ້ວ';
  static const String userNotFound = 'ບໍ່ພົບຜູ້ໃຊ້';
  static const String wrongPassword = 'ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ';
  static const String fieldRequired = 'ກະລຸນາປ້ອນຂໍ້ມູນ';

  // Success Messages
  static const String bookCreatedSuccessfully = 'ສ້າງປຶ້ມສຳເລັດ';
  static const String chapterPublishedSuccessfully = 'ເຜີຍແຜ່ບົດສຳເລັດ';
  static const String profileUpdatedSuccessfully = 'ອັບເດດໂປຣໄຟລ໌ສຳເລັດ';
  static const String savedSuccessfully = 'ບັນທຶກສຳເລັດ';

  // Confirmation
  static const String areYouSure = 'ທ່ານແນ່ໃຈບໍ່?';
  static const String deleteBookConfirmation =
      'ທ່ານຕ້ອງການລຶບປຶ້ມເຫຼັ້ມນີ້ບໍ່?';
  static const String deleteChapterConfirmation = 'ທ່ານຕ້ອງການລຶບບົດນີ້ບໍ່?';
  static const String discardChangesConfirmation =
      'ທ່ານຕ້ອງການຍົກເລີກການປ່ຽນແປງບໍ່?';
  static const String yes = 'ແມ່ນ';
  static const String no = 'ບໍ່';
  static const String cancel = 'ຍົກເລີກ';
  static const String delete = 'ລຶບ';
  static const String discard = 'ຍົກເລີກ';
  static const String save = 'ບັນທຶກ';

  // Empty States
  static const String noBooksYet = 'ຍັງບໍ່ມີປຶ້ມ';
  static const String startYourFirstBook = 'ເລີ່ມຂຽນປຶ້ມເຫຼັ້ມທຳອິດຂອງທ່ານ';
  static const String noChaptersYet = 'ຍັງບໍ່ມີບົດ';
  static const String addYourFirstChapter = 'ເພີ່ມບົດທຳອິດຂອງທ່ານ';

  // Loading
  static const String loading = 'ກຳລັງໂຫຼດ...';
  static const String pleaseWait = 'ກະລຸນາລໍຖ້າ...';
  static const String savingChanges = 'ກຳລັງບັນທຶກ...';
  static const String publishing = 'ກຳລັງເຜີຍແຜ່...';
}
