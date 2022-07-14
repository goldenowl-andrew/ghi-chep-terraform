# Module overview
- Khi bạn quản lý cơ sở hạ tầng của bạn bằng Terraform, bạn sẽ thấy số lượng cấu hình càng ngày càng phức tạp và gia tăng. Sẽ không có giới hạn nào đối với sự phức tạp của một file hoặc directory cấu hính Terraform, vì vậy bạn có thể tiếp tục viết và update config file bên trong một single directory. Tuy nhiên, nếu làm vậy bạn có thể sẽ gặp một vài vấn đề như sau:
  - Việc quản lý và nắm bắt các file cấu hình sẽ trở nên phức tạp.
  - Update configuration sẽ trở lên nhiều rủi ro hơn, có thể bản cập nhật của 1 section sẽ gây ra một số kết quả không muốn tới các section khác.
  - Sẽ ngày càng có nhiều sự trùng lặp của các block configuration giống nhau, ví dụ như khi chia cấu hình riêng biệt cho từng môi trường dev/staging/production. Điều này sẽ gây ra sự phức tạp khi muốn update cấu hình.
  - Bạn có thể muốn share các phần cấu hình của mình  giữa các project hay teams, và việc copy & paste giữa các project hay team sẽ dễ xảy ra lỗi và khó bảo trì

**-->** Trong bài này sẽ chỉ ra cách module  giải quyết những vấn đề trên, cấu trúc của module trong terraform và các best practice khi sử dụng và tạo module.
# What are modules for?
- Dưới đây là một số cách mà module giải quyết những vấn đề trên:
  - Organize configuration: Module giúp điều hướng và cập nhật cấu hình của bạn dễ dàng hơn bằng cách giữ các phần liên quan của cấu hình lại với nhau. Ngay cả những hạ tầng phức tạp vừa phải cũng có thể yêu cầu hàng trăm đến nghìn dòng cấu hình triển khai. Sử dụng module có thể giúp tổ chức các thành phần logic hơn.
  - Encapsulate configuration: Một lợi ích khác khi sử dụng module là đóng gói các cấu hình bên trong các thành phần logic riêng biệt. Việc đóng gói có thể giúp ngăn chặn những kết quả không mong muốn, chẳng hạn như việc thay đổi một phần cấu hình của bạn vô tình làm thay đổi cấu hình của các hạ tầng khác và giảm nguy các mắc các lỗi đơn giản như vô tình sử dụng cùng 1 tên cho 2 loại tài nguyên khác nhau.
  - Re-use configuration: Việc viết tất cả các cấu hình của bạn từ đầu sẽ gây mất thời gian và dễ xảy ra lỗi. Sử dụng module sẽ tiết kiệm được thời gian và giảm các lỗi bằng cách sử dụng lại cấu hình được viết bởi chính bạn, team của bạn hoặc những người khác đã xuất bản module để bạn sử dụng. Bạn có thể chia sẻ các module mà bạn viết hoặc public các module đó.
  - Provide consistency and ensure best practices: Tính nhất quán không chỉ làm cho các cấu hình phức tạp trở nên dễ hiểu hơn mà nó còn đảm bảo các phương pháp hay nhất được áp dụng trên tất cả các cấu hình của bạn. Ví dụ, cloud provider cung cấp các lực chọn cho việc cấu hình object storage service như Amazon S3, Google Cloud Storage buckets. Đã có nhiều sự cố bảo mật cấp cao liên quan đến việc lưu trữ các object được bảo mật không chính xác, 
  - Provide consistency and ensure best practices: Tính nhất quán không chỉ làm cho các cấu hình phức tạp trở nên dễ hiểu hơn mà nó còn đảm bảo các phương pháp hay nhất được áp dụng trên tất cả các cấu hình của bạn. Ví dụ, cloud provider cung cấp các lực chọn cho việc cấu hình object storage service như Amazon S3, Google Cloud Storage buckets. Đã có nhiều sự cố bảo mật cấp cao liên quan đến việc lưu trữ các object được bảo mật không chính xác, và với số lượng tùy chọn cấu hình phức tạp liên quan, rất dễ vô tình định cấu hình sai các dịch vụ này.

# What is a Terraform module?
- Terraform module là một tập hợp các tệp cấu hình Terraform trong một thư mục duy nhất. Ngay cả một cấu hình đơn giản bao gồm một thư mục với một hoặc nhiều tệp .tf cũng là một mô-đun. Khi bạn chạy các lệnh Terraform trực tiếp từ một thư mục như vậy, nó được coi là ```root module```. Do vậy theo nghĩa này, mọi cấu hình terraform đều là 1 phần của 1 module. Bạn có thể có một tập hợp các tệp cấu hình Terraform đơn giản như:
```
.
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```
# Calling modules
- Terraform command sẽ chỉ trực tiếp sử dung các file cấu hình trong 1 thư mực, thường là current working directory. Tuy nhiên, configuration của bạn có thể sử dụng module block để gọi các module khác trong các thư mục khác. Khi terraform gặp các block đó, nó sẽ load và thực thi các config file của module đó.
- Một module được gọi bởi cấu hình khác đôi khi được gọi là `child module` của cấu hình đó.
# Local and remote modules
- Module có thể được load từ local filesystem hoặc remote source.
- Terraform hỗ trợ nhiều remote source, bao gồm terraform registry, hầu hết các VCS (github, gitlab,..), HTTP URLs, terraform cloud hay Terraform Enterprise private module registries.

# Module best practices
- Terraform module là một khái niệm tương tự như libraries, packages hoặc các module được biết trong các ngôn ngữ lập trình và nó cũng cung câp nhiều lơi ích tương tự.
- Một số practice khi sử dụng Terraform module.
  - Đặt tên: `terraform-<PROVIDER>-<NAME>`. Tuân theo các quy tắc sau: [publish to the Terraform Cloud or Terraform Enterprise module registries.](https://www.terraform.io/docs/cloud/registry/publish.html)
  - Sử dụng local module để tổ chức và đóng gói code của bạn. Ngay cả khi bạn không sử dụng hay publish remote module, tổ chức cấu hình của bạn theo module ngay từ đầu sẽ giảm đáng kể gánh nặng duy trì và cập nhật cấu hình của bạn khi cơ sở hạ tầng của bạn ngày càng phức tạp.
  - Sử dụng public registry để tìm các module hữu ích. Bằng cách này, bạn có thể triển khai cấu hình của mình nhanh chóng và tự tin hơn bằng cách dựa vào công việc của những người khác để triển khai các kịch bản cơ sở hạ tầng chung
  - Publish và share module giữa team của bạn. Hầu hết cơ sở hạ tầng được quản lý bởi một nhóm người và các module là cách quan trọng mà các nhóm có thể làm việc cùng nhau để tạo và duy trì cơ sở hạ tầng