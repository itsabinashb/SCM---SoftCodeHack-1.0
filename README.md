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

`store(uint256 _materialId)` : The storekeeper needs to call this function with the id of a material which he wants to store.

`packing(uint256 _productId)`: The packer needs to call this function with the id of a product which he wants to pack.

`ship(uint256 _productId)` : The shipper needs to call this function with the id of a product which he wants to ship.

`Sell(uint256 _productId)`: The seller needs to call this function with the id of a product which he wants to sell.

`getProductMetadata(uint256 _productId)` : This is most important function for consumers. A consumer can fetch the address of seller, packer, manufacturer, shipper, supplier and storekeeper's as a figure of metadata.

### Let's know the events:

1. `RawMaterialSupplied`: This event is emitted when a supplier supplies raw materials. It provides information about the amount of material supplied, the material ID, and the address of the supplier.
2. `ProductAdded`: This event is emitted when a new product is listed by the manufacturer. It includes the name of the product and its unique product ID.
3. `RawMaterialAdded`: This event is emitted when a new raw material is listed by the manufacturer. It provides information about the name of the material, the amount of material, and its unique material ID.
4. `StoredBy`: This event is emitted when a storekeeper marks that they have stored a specific material. It includes the address of the storekeeper and the material ID.
5. `PackerAdded`: This event is emitted when a packer is assigned to a specific product. It includes the address of the packer and the product ID.
6. `ShipperForProduct`: This event is emitted when a shipper is assigned to a specific product for shipping. It includes the address of the shipper and the product ID.
7. `ProductReceivedBySeller`: This event is emitted when a seller marks that they have received a specific product. It includes the address of the seller and the product ID.
8. `SupplierRegistered`: This event is emitted when an address registers as a supplier for a specific product. It includes the address of the supplier and the product ID.
9. `StorekeeperRegistered`: This event is emitted when an address registers as a storekeeper for a specific product. It includes the address of the storekeeper and the product ID.
10. `PackerRegistered`: This event is emitted when an address registers as a packer for a specific product. It includes the address of the packer and the product ID.
11. `ShipperRegistered`: This event is emitted when an address registers as a shipper for a specific product. It includes the address of the shipper and the product ID.
12. `SellerRegistered`: This event is emitted when an address registers as a seller for a specific product. It includes the address of the seller and the product ID.

These events serve as notifications or logs for different actions and state changes within the supply chain management contract.
