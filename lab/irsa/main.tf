
provider "aws" {
  region = var.region
}
data "external" "thumb" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer]
}
data "aws_eks_cluster" "cluster" {
  name = "eks_cluster"
}
### OIDC config
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumb.result.thumbprint]
  url             = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}


resource "aws_iam_role" "aws_node" {
  name               = "${var.tags["ServiceType"]}-${var.tags["Environment"]}-aws-node"
  assume_role_policy = templatefile("oidc_assume_role_policy.json", { OIDC_ARN = aws_iam_openid_connect_provider.cluster.arn, OIDC_URL = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""), NAMESPACE = "default", SA_NAME = "sa-node" })
  tags = merge(
    var.tags,
    {
      "ServiceAccountName"      = "aws-node"
      "ServiceAccountNameSpace" = "kube-system"
    }
  )
  depends_on = [aws_iam_openid_connect_provider.cluster]
}
resource "aws_iam_role_policy_attachment" "aws_node" {
  role       = aws_iam_role.aws_node.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  depends_on = [aws_iam_role.aws_node]
}
