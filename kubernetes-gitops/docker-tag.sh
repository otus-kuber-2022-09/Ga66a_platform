export VER="v0.0.1"
declare -a images=("adservice" "cartservice" "checkoutservice" "currencyservice" "emailservice" "frontend" "loadgenerator" "paymentservice" "productcatalogservice" "recommendationservice" "shippingservice")
for image in "${images[@]}"
do
  docker pull avtandilko/${image}
  docker tag avtandilko/${image} ga66a/${image}:${VER}
  docker container commit ga66a/${image}:${VER}
  docker push ga66a/${image}:${VER}
done