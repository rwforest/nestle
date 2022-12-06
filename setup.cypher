// Nodes
LOAD CSV WITH HEADERS FROM 'file:///suppliers.csv' AS row
MERGE (
	n:Supplier{
		`Supplier Name`:row.Supplier_Name,
		City:row.City,
		Country:row.Country,
		Sales:toFloat(row.Sales),
		`RM Category`: row.RM_Category,
		`Process Category`: row.Process_Category,
		`Main products they mfg`: row.Main_products_they_mfg,
		`Established Yr`:toInteger(row.Established_Yr),
		Customer: row.Customer,
		`Financial Risk Score`:toFloat(row.Financial_Risk_Score),
		`Risk Category`: row.Risk_Category,
		`Part mapped with BOM`: row.Part_mapped_with_BOM
		}
);

// Edges
LOAD CSV WITH HEADERs FROM 'file:///edges.csv' AS row
MATCH (a:Supplier{`Supplier Name`:row.From}), (b:Supplier{`Supplier Name`:row.To})
MERGE (a)-[r:SUPPLIES_TO]->(b);