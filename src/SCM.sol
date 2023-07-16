// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SCM {
  struct Product {
    string productName;
    uint256 productId;
  }
  struct Material {
    string name;
    uint256 amount;
    uint256 materialId;
    uint256 forProduct;
  }

  struct ProductMetadata {
    address supplier;
    address packer;
    address storekeeper;
    address manufacturer;
    address shipper;
    address seller;
  }

  enum Status {
    exist,
    doNotExist,
    _true,
    _false,
    set,
    unset
  }

  enum MaterialStatus {
    flop,   // this was added to deal with one of an enum's property which is enum has default value = 0
    setToSupply,
    setToStore
    }

  enum ProductStatus {
    flop, // this was added to deal with one of an enum's property which is enum has default value = 0
    setToPack,
    setToShip,
    setToSell
  }

  event RawMaterialSupplied(uint256 amountOfMaterial, uint256 materialId, address supplier);
  event ProductAdded(string productName, uint256 productId);
  event RawMaterialAdded(string materialName, uint256 amountOfMaterial, uint256 materialId);
  event StoredBy(address storeKeeper, uint256 materialId);
  event PackerAdded(address Packer, uint256 productId);
  event ShipperForProduct(address shipper, uint256 productId);
  event ProductReceivedBySeller(address seller, uint256 productId);
  event SupplierRegistered(address supplier, uint256 productId);
  event StorekeeperRegistered(address storekeeper, uint256 productId);
  event PackerRegistered(address packer, uint256 productId);
  event ShipperRegistered(address shipper, uint256 productId);
  event SellerRegistered(address seller, uint256 productId);

  mapping(address => mapping(uint256 => uint256)) rawMaterialSupplier; // supplier => materialId => amount, who supplying => which material => how much amount
  mapping(uint256 => Status) public existingProduct; // mapping to know whether the product exists or not
  mapping(uint256 => Status) public existingMaterial; // mapping to know whether the material exists or not
  mapping(uint256 => uint256) fixedMaterialAmount; // materialId => the fixed amount limit of that material Id
  mapping(uint256 => uint256) totalAmount; // materialId => total amount of material is deposited till now
  mapping(address => mapping(uint256 => Status)) storedBy; // who storing => which material (Id) => stored(_true) or not(_false)
  mapping(uint256 => Status) productIdToStatus; // mapping to set or unset a productId for packing
  mapping(address => uint256) shipmentRecord; // shipper => which product (id) the shipper is shipping
  mapping(uint256 => Status) shipmentStatus; // shipment is set or unset of a product, productId => set/unset to ship
  mapping(uint256 => Status) productReceivedBySeller; // productId => product received by seller (_true) or not(_false)
  mapping(uint256 => ProductMetadata) productMetadata; // metadata of a product
  mapping(uint256 => uint256) materialIdToProductId;
  mapping(uint256 => Material[]) public materialForProduct;
  mapping(uint256 => MaterialStatus) public materialStatus;
  mapping(uint256 => ProductStatus) public productStatus;
  mapping(uint256 => bool) public existingProductId;
  mapping(uint256 => bool) public existingMaterialId;
  mapping(address => uint256[]) supplierToMaterialIds;
  mapping(address => uint256[]) storekeeperToMaterialIds;
  mapping(address => uint256[]) packerToProductIds;
  mapping(address => uint256[]) shipperToProductIds;
  mapping(address => uint256[]) sellerToProductIds;
 // mapping(uint256 => Product[]) public listOfProducts;
  mapping(address => uint256[])  SupplierOfMaterials;
  //string[] public materials;
  //mapping(uint256 => Material[]) public listedMaterials;
  Product[] public listOfProducts;
  Material[] public listOfMaterials;
  uint256 materialId = 0;
  uint256 productId = 0;
  address Manufacturer;
  address[] supplier;
  address[] storeKeeper;
  address[] packer;
  address[] shipper;
  address[] seller;

  constructor() {
    Manufacturer = msg.sender;
  }

  /**
   * @notice Manufacturer will call this function to list products. This function will list all products from the manufacturer.
   * @param _productName  name of the product
   */
  function listProducts(string memory _productName) external onlyManufacturer returns(uint256){
    productId++;
    listOfProducts.push(Product(_productName, productId));
    existingProduct[productId] = Status.exist; // Setting the status of the Product name.
    productIdToStatus[productId] = Status.unset;  
    existingProductId[productId] = true;
    productMetadata[productId].manufacturer = Manufacturer;
    emit ProductAdded(_productName, productId);
    return productId;
  }

  /**
   * @notice Manufacturer will call this function list all raw material for his/her products
   * @param _name name of the raw material which will be used to make a product
   * @param _amount amount of the raw material, ex- 100 kgs.
   * @param _productId The id of the product for which material will be listed
   */
  function listMaterial(string memory _name, uint256 _amount, uint256 _productId) external onlyManufacturer {
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    require(existingProductId[_productId], "Product id does not exist");
    materialId++;
    existingMaterialId[materialId] = true;
   listOfMaterials.push(Material(_name, _amount, materialId, _productId));
    existingMaterial[materialId] = Status.exist; // Setting current status of the material, it is now exist
    materialForProduct[_productId].push(Material(_name, _amount, materialId, _productId)); // for a particular product this material is added
    fixedMaterialAmount[materialId] = _amount; // the fixed amount of material because we don't want unlimited material
    materialIdToProductId[materialId] = _productId;  // this materialId is for this productId
    emit RawMaterialAdded(_name, _amount, materialId);
  }

  function removeProduct(uint256 _productId) public onlyManufacturer {
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    for(uint256 i = 0; i < listOfProducts.length; i++){
      if (_productId == listOfProducts[i].productId){
        delete listOfProducts[i];
      }
    }
    existingProduct[_productId] = Status.doNotExist;
    existingProductId[_productId] = false;
  }

  function removeMaterial(uint256 _materialId) public onlyManufacturer {
    require(existingMaterialId[_materialId], "Material id does not exist");
    require(existingMaterial[_materialId] == Status.exist, "productId doesn't exist!");
    for(uint256 i = 0; i < listOfMaterials.length; i++){
      if (_materialId == listOfMaterials[i].materialId){
        delete listOfMaterials[i];
      }
    }
    existingMaterial[_materialId] = Status.doNotExist;
    existingMaterialId[_materialId] = false;
  }

  /**
   * @notice caller will call this function to register himself as a supplier of the particular material
   * @param _materialId The id of the material for which this caller wants to be supplier
   */
  function registerAsSupplier(uint256 _materialId) external onlyEOA noEmptyAddressCaller {
    require(existingMaterialId[_materialId], "Material id does not exist");
    require(existingMaterial[_materialId] == Status.exist, 'material Id does not exist!'); // Checking whether material id exists or not
    require(productMetadata[_materialId].supplier != msg.sender); // Confirming that caller is not already a supplier of that material
    supplier.push(msg.sender); // Recording all supplier in an array
    productMetadata[materialIdToProductId[_materialId]].supplier = msg.sender;
    SupplierOfMaterials[msg.sender].push(_materialId);
    
    emit SupplierRegistered(msg.sender, _materialId);
  }

  /**
   * @notice Caller will call this function to register himself as a storekeeper of this particular material
   * @param _materialId The id of the material which this caller wants to store
   */
  function registerAsStoreKeeper(uint256 _materialId) external onlyEOA noEmptyAddressCaller {
     require(existingMaterialId[_materialId], "Material id does not exist");
    require(existingMaterial[_materialId] == Status.exist, 'material Id does not exist!'); // Checking whether material id exists or not
    require(productMetadata[_materialId].storekeeper != msg.sender); // Confirming that caller is not already a storekeeper of that material
    
    storeKeeper.push(msg.sender);
    
    productMetadata[materialIdToProductId[_materialId]].storekeeper = msg.sender;
    emit StorekeeperRegistered(msg.sender, _materialId);
  }

  /**
   * @notice Caller will call this function to register himself as a packer of this particular product
   * @param _productId The id of the product which caller wants to pack
   */
  function registerAsPacker(uint256 _productId) external onlyEOA noEmptyAddressCaller {
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!"); // Checking whether product id exists or not
    require(productMetadata[_productId].packer != msg.sender); // Confirming that caller is not already a packer of that material
    packer.push(msg.sender);
    
    productMetadata[_productId].packer = msg.sender;
    emit PackerRegistered(msg.sender, _productId);
  }

  /**
   * @notice Caller will call this function to register himself as a shipper of this particular product
   * @param _productId The id of the product which caller wants to ship
   */
  function registerAsShipper(uint256 _productId) external onlyEOA noEmptyAddressCaller {
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!"); // Checking whether product id exists or not
    require(productMetadata[_productId].shipper != msg.sender); // Confirming that caller is not already a shipper of that material
    
    shipper.push(msg.sender);
    
    productMetadata[_productId].shipper = msg.sender;
    emit ShipperRegistered(msg.sender, _productId);
  }

  /**
   * @notice Caller will call this function to register himself as a seller of this particular product
   * @param _productId The id of the product which caller wants to seller
   */
  function registerAsSeller(uint256 _productId) external onlyEOA noEmptyAddressCaller {
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!"); // Checking whether product id exists or not
    require(productMetadata[_productId].seller != msg.sender); // Confirming that caller is not already a seller of that material
    
    seller.push(msg.sender);
    productMetadata[_productId].seller = msg.sender;
    emit SellerRegistered(msg.sender, _productId);
  }

  /**
   * @notice Suppliers will call this function if the want to supply this raw material
   * @param _materialId ID of the raw material which was set by the manufacturer
   * @param _amount amount of the material supplier wants to supply
   */
  function supplyRawMaterials(uint256 _materialId, uint256 _amount) external onlyEOA noEmptyAddressCaller {
    bool isSupplier = false;
    for(uint256 i = 0; i < SupplierOfMaterials[msg.sender].length; i++){
      if(SupplierOfMaterials[msg.sender][i] == _materialId){
        isSupplier = true;
      }
    }
    require(isSupplier, "You can't supply the material because you have not registered as the supplier of the material");
     require(existingMaterialId[_materialId], "Material id does not exist");
    require(
      msg.sender == productMetadata[materialIdToProductId[_materialId]].supplier,
      "You can't supply materials because you did not register as supplier for this material"
    );
    require(
      existingMaterial[_materialId] == Status.exist,
      'material Id does not exist, please enter valid material Id'
    ); // confirming that material is exist
    require(totalAmount[_materialId] < fixedMaterialAmount[_materialId], 'Has enough amount!'); // checking whether the amount of material exceeding than fixed amount or not
    rawMaterialSupplier[msg.sender][_materialId] = _amount++; // recording that which supplier added how many amount of material
    totalAmount[_materialId] = _amount++; // adding the material amount in previous amount
    materialStatus[_materialId] = MaterialStatus.setToSupply;
    supplierToMaterialIds[msg.sender].push(_materialId);
    emit RawMaterialSupplied(_amount, _materialId, msg.sender);
  }

  function store(uint256 _materialId) external noEmptyAddressCaller onlyEOA {
    bool isSupplier = false;
    for(uint256 i = 0; i < SupplierOfMaterials[msg.sender].length; i++){
      if(SupplierOfMaterials[msg.sender][i] == _materialId){
        isSupplier = true;
      }
    }
    require(materialStatus[_materialId] == MaterialStatus.setToSupply, "Material was not supplied yet!");
    require(isSupplier, "You can't store the material because you have not registered as the supplier of the material");
     require(existingMaterialId[_materialId], "Material id does not exist");
    require(existingProduct[_materialId] == Status.exist, "productId doesn't exist!");
    require(
      msg.sender == productMetadata[_materialId].storekeeper,
      "You can't store materials because you did not register as storekeeper for this material"
    );
    storedBy[msg.sender][_materialId] = Status._true;
    storekeeperToMaterialIds[msg.sender].push(_materialId);
    materialStatus[_materialId] = MaterialStatus.setToStore;
    emit StoredBy(msg.sender, _materialId);
  }

  function packing(uint256 _productId) external onlyEOA noEmptyAddressCaller {
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    require(
      msg.sender == productMetadata[_productId].packer,
      "You can't pack product because you did not register as packer for this product"
    );
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    require(productIdToStatus[_productId] == Status.unset, "Packer already enployed");
    productIdToStatus[_productId] = Status.set;
    packerToProductIds[msg.sender].push(_productId);
    productStatus[_productId] = ProductStatus.setToPack;
    emit PackerAdded(msg.sender, _productId);
  }

  function ship(uint256 _productId) external onlyEOA noEmptyAddressCaller {
    require(productStatus[_productId] == ProductStatus.setToPack, "Product was not packed yet");
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    require(
      msg.sender == productMetadata[_productId].shipper,
      "You can't ship product because you did not register as shipper for this product"
    );
    require(shipmentStatus[_productId] != Status.set, 'Shippers already set!');
    
    shipmentRecord[msg.sender] = _productId;
    shipperToProductIds[msg.sender].push(_productId);
    shipmentStatus[_productId] = Status.set;
    productStatus[_productId] = ProductStatus.setToShip;
    emit ShipperForProduct(msg.sender, _productId);
  }

  function Sell(uint256 _productId) external onlyEOA noEmptyAddressCaller {
    require(existingProductId[_productId], "Product id does not exist!");
    require(productStatus[_productId] == ProductStatus.setToShip, "Product has not shipped yet!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    require(
      msg.sender == productMetadata[_productId].seller,
      "You can't sell product because you did not register as seller for this product"
    );
    
    productReceivedBySeller[_productId] = Status._true;
    sellerToProductIds[msg.sender].push(_productId);
    productStatus[_productId] = ProductStatus.setToSell;
    emit ProductReceivedBySeller(msg.sender, _productId);
  }

  function getProductMetadata(uint256 _productId) public view returns (ProductMetadata memory) {
    require(existingProductId[_productId], "Product id does not exist!");
    require(existingProduct[_productId] == Status.exist, "productId doesn't exist!");
    return productMetadata[_productId];
  }

  modifier noEmptyAddressCaller() {
    require(msg.sender != address(0), 'Cannot be called by an empty address!');
    _;
  }

  modifier onlyEOA() {
    require(msg.sender.code.length == 0, 'Can only be called by EOAs');
    _;
  }

  modifier onlyManufacturer() {
    require(msg.sender == Manufacturer, 'Only manufacturer can call this function!');
    _;
  }
}


