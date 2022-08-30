//Clear all nodes and Relationships
MATCH (n) DETACH DELETE n;

// Nodes
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/file/d/1b3_JfutKAHSb4MKMwlz5VS7LJdbaZy8e/view?usp=sharing' AS row
MERGE (
	n:SKU{
		SKU:row.SKU,
		Priceperunit:toFloat(row.Priceperunit),
		Qty:toInteger(row.Qty),
		Unit:row.Unit
		}
);

LOAD CSV WITH HEADERS FROM 'file:///mat.csv' AS row
MERGE (
	n:Material{
		Material_ID:toInteger(row.Material_No),
		Material_Description:row.Material_Description,
		Risk:toFloat(row.Risk)
	}
);

LOAD CSV WITH HEADERS FROM 'file:///order.csv' AS row
MERGE (
	n:Order{
		Plant_ID:toInteger(row.Plant_ID),
		Purchase_Order:toInteger(row.Purchase_Order),
		Planned_Delivery:row.Planned_Delivery,
		Vendor_ID:toInteger(row.Vendor_ID),
		Material_ID:toInteger(row.Material_ID),
		Order_Qty:toInteger(row.Order_Qty)
	}
);

LOAD CSV WITH HEADERS FROM 'file:///vendor.csv' AS row
MERGE (
	n:Vendor{
		Vendor_ID:toInteger(row.Vendor_ID),
		Material_ID:toInteger(row.Material_ID),
		City: row.VS_City,
		State: row.VS_region,
		Country: row.VS_country,
		Cost_per_unit:toInteger(row.Cost_per_unit),
		Monthly_Capacity:toInteger(row.Monthly_Capacity),
		Name:row.Name,
		Risk:row.Risk
		}
);

LOAD CSV WITH HEADERS FROM 'file:///plant.csv' AS row
MERGE (
	n:Plant{
		PlantID:toInteger(row.ID),
		PlantName:row.PlantName,
		City: row.City,
		State: row.State,
		Country: row.Country
	}
);

LOAD CSV WITH HEADERS FROM 'file:///wh.csv' AS row
MERGE (
	n:Warehouse{
		WH_ID:row.WH_ID,
		WH_Name:row.WH_Name,
		City: row.City,
		State: row.State,
		Country: row.Country	
	}
);

LOAD CSV WITH HEADERs FROM 'file:///customer.csv' AS row
MERGE (
	n:Customer{
		Customer_ID:row.Customer_ID,
		CustomerCity:row.CustomerCity,
		CustomerCountry:row.CustomerCountry,
		FirstName:row.FirstName,
		LastName:row.LastName
	}
);

LOAD CSV WITH HEADERs FROM 'file:///risk.csv' AS row
MERGE (
	n:Risk{		
		_Risk_Reason:row.Risk_Reason,
		Risk_Category:row.Risk_Category
	}
);

LOAD CSV WITH HEADERs FROM 'file:///cost_benefit_analysis.csv' AS row
MERGE (
	n:CostBenefit{
		Cost_of_switch: row.Cost_of_switch,
		Potential_Revenue_Saved: row.Potential_Revenue_Saved
	}
);


// Edges
LOAD CSV WITH HEADERs FROM 'file:///bom.csv' AS row
MATCH (a:SKU{SKU:row.SKU}), (b:Material{Material_ID:toInteger(row.Material_No)})
MERGE (a)-[r:CONTAINS]->(b);

LOAD CSV WITH HEADERs FROM 'file:///order.csv' AS row
MATCH (a:Material{Material_ID:toInteger(row.Material_ID)}), (b:Order{Purchase_Order:toInteger(row.Purchase_Order)})
MERGE (a)-[r:PROCURED_FROM]->(b);

LOAD CSV WITH HEADERs FROM 'file:///order.csv' AS row
MATCH (a:Order{Purchase_Order:toInteger(row.Purchase_Order)}), (b:Vendor{Vendor_ID:toInteger(row.Vendor_ID)})
MERGE (a)-[r:SOURCED_FROM]->(b);

LOAD CSV WITH HEADERs FROM 'file:///v2p.csv' AS row
MATCH (a:Vendor{Vendor_ID:toInteger(row.Vendor_ID)}), (b:Plant{PlantID:toInteger(row.Plant_ID)})
MERGE (a)-[r:SHIPS_TO]->(b);

LOAD CSV WITH HEADERs FROM 'file:///plant2dc.csv' AS row
MATCH (a:Plant{PlantID:toInteger(row.Plant_ID)}), (b:Warehouse{WH_ID:row.Warehouse_ID})
MERGE (a)-[r:SENDS_TO]->(b);

LOAD CSV WITH HEADERs FROM 'file:///wh2c.csv' AS row
MATCH (a:Warehouse{WH_ID:row.Warehouse_ID}), (b:Customer{Customer_ID:row.Customer_ID})
MERGE (a)-[r:DISTRUBUTES_TO]->(b);

LOAD CSV WITH HEADERs FROM 'file:///Revised_Vendor_Risk.csv' AS row
MATCH (a:Vendor{Vendor_ID:toInteger(row.Vendor_ID)}), (b:Risk{Risk_Category:row.Risk_Category,_Risk_Reason:row.Risk_Reason})
MERGE (a)-[r:AT_RISK{Risk_Score:toFloat(row.Risk_Score)}]->(b);

LOAD CSV WITH HEADERs FROM 'file:///cost_benefit_analysis.csv' AS row
MATCH (a:Vendor{Vendor_ID:toInteger(row.Vendor_ID)}), (b:CostBenefit{Cost_of_switch: row.Cost_of_switch, Potential_Revenue_Saved: row.Potential_Revenue_Saved})
MERGE (a)-[r:ANALYZE]->(b);

LOAD CSV WITH HEADERs FROM 'file:///altvendor.csv' AS row
MATCH (a:Vendor{Vendor_ID:toInteger(row.From_vendor_id)}), (b:Vendor{Vendor_ID:toInteger(row.To_vendor_id)})
MERGE (a)-[r:SWITCH]->(b);