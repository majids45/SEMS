Data Requirements 
The database needs to store owner information, property details (including type - residential or commercial), address, total area, and household size (for residential properties). It shall also store appliance data, such as appliance type, brand, and status.
The database shall maintain tariff rates, which vary based on state, including historical records in cost changes over time.
The system will store energy usage per individual appliances. For business users, it will track energy usage by appliance and unit.
The system shall support both residential and commercial property acount, allowing a single owner to manage multiple properties, which may include both residential and commercial types (e.g., a home and an office).
Each user will have the ability to control their appliances, set custom schedules, such as turning appliances on or off, and activate energy-saving modes within specific times.
Business Rules and Logic 
Each user can maintain both a residential and a commercial account, ensuring that all personal and business-related energy data is kept under the correct ownership.
Each account (whether residential or commercial) belongs to only one user, preserving a clear one-to-one or one-to-many relationship from the user’s perspective.
Each commercial property can be subdivided into multiple units, while every unit is associated with exactly one commercial property.
Each property or commercial unit can host multiple appliances, and every appliance is strictly linked to one property or unit.
Owners can define multiple schedules for each appliance, allowing flexibility in operating times and off-peak usage, while each schedule is maintained by a single user.
Tariff data is kept separate, ensuring that any changes in cost rates do not require rewriting historical usage records; instead, cost can be calculated on the fly by referencing the relevant tariff.
Foreign key constraints prevent deleting parent records (like users, tariffs, or accounts) when dependent child records still exist, enforcing referential integrity.
Primary key constraints ensure each entity (user, property, appliance, etc.) is uniquely identifiable, while CHECK constraints maintain valid numeric ranges for fields like household size, total area, and cost per watt.
Other Assumptions 
All electrical appliances are equipped with smart sensors capable of reporting energy consumption data in real-time.
Each smart appliance is registered and assigned to a specific residential property or commercial unit.
Only authorized users, such as property owners, landlords, or designated contacts, have access to the system.
Users can set one schedule at a time for each device, such that the start and end times do not overlap.
Energy Metrics that capture appliance readings will be recorded on a daily basis.
