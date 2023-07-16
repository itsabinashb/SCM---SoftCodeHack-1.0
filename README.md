# SUPPLY CHAIN MANAGEMENT DAPP

### What this contract does?

In this contract the owner is **manufacturer**. Suppose you are a manufacturer, you want to manufacture some product. For this you need raw materials, supplying facility of raw materials, packing facility, you might need a storeroom to store all product or raw materials, you also need a shipper who will ship your product to seller and eventually you also need sellers who will sell your product. So we are building this application to keep track of every information related to a particular product from its time to produce to selling the product so that any general public or customer an see the history of product. One amazing thing about this contract is this is **dynamic** means this contract is applicable to hold any product's record which holds raw material supplying info, storing, shipping info.

### Who will deploy the contract?

This contract should be deployed by manufacturer.

### Let's know the functions:

`listProducts(string memory _productName)` : This function should be called by maufacturer. This functions lists all products and assigns unique *id* for each product.

`listMaterial(stringmemory _name, uint256 _amount, uint256 _productId)` : This function should also be called by manufacturer. It takes a *productId* which should exist in contract while passing as argument. This function also assigns an unique *id* for each material.

`removeProduct(uint256 _productId)` : This function should be called by manufacturer to remove any product from all product currently exist in contract. It takes the *productId* of the particular product which to be removed.

`removeMaterial(uint256 _materialId)` : This function should be called by manufacturer to remove any material from all material currently exist in contract. It takes the *materialId* of the particular material which to be removed.

> To take resposibily of supplying raw material, storing, shipping, packing and selling the product one must register himself. Lets know the functions for this purpose.


`registerAsSupplier(uint256 _materialId)` : This function is for registering as supplier. In this contract if someone wants to supply raw material for any product he/she needs to register as a supplier. Here anybody can be a supplier even manufacturer can be a supplier but he also needs to register.

`registerAsStoreKeeper(uint256 _materialId)`: Every material need to store somewhere. This function is for those who want to store that particular material. He needs to register himself as storekeeper of that the material.

`registerAsPacker(uint256 _productId)` : After manufacturing a  product need to be packed. This function is for those who want to take responsibility to pack a product. He needs to register himself by providing a particular product id of a particular product.

`registerAsShipper(uint256 _productId)` : This function is for those who wants to take responsibility to ship a product  to seller.

`registerAsSeller(uint256 _productId)` : This function is for who wants to sell the product. To be seller needs to register himself as as seller otherwise he can't sell the product.

`supplyRawMaterials(uint256 _materialId, uint256 _amount)` : After registering a supplier need to provide information what material he want to supply and how much amount he want to supply. It has multiple security checks.

`store(uint256 _materialId)` : The storekeeper
