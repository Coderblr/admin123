import { useState } from "react";
import { styles } from "../../styles/AppStyles";

export default function LoginPage({ onLoginSuccess, onNavigate }) {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    const handleLogin = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError("");

        try {
            const response = await fetch("http://10.1.161.165:5050/token", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: new URLSearchParams({
                    username,
                    password,
                }),
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.detail || "Login failed");
            }

            const data = await response.json();
            const authToken = data.access_token;
            const userType = data.user_type ?? 0; // 1 = admin, 0 = user

            // store auth data
            localStorage.setItem("userToken", authToken);
            localStorage.setItem("userType", String(userType));

            // pass token + role to parent
            onLoginSuccess(authToken, userType);

            setUsername("");
            setPassword("");
        } catch (err) {
            setError(err.message || "Something went wrong");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={styles.authContainer}>
            <div style={styles.authSplit}>
                <div style={styles.authLeft}>
                    <div style={styles.authBrand}>
                        <div style={styles.logoCircle}>SBI</div>
                        <span style={styles.brandText}>State Bank of India</span>
                    </div>

                    <h1 style={styles.authLeftTitle}>Welcome Back</h1>
                    <p style={styles.authLeftSubtitle}>
                        Sign in to access your test data creation platform
                    </p>

                    <div style={styles.authFeatureList}>
                        <div style={styles.authFeature}>✓ Automated CIF Generation</div>
                        <div style={styles.authFeature}>✓ CCOD Account Creation</div>
                        <div style={styles.authFeature}>✓ Deposit Management</div>
                    </div>
                </div>

                <div style={styles.authRight}>
                    <div style={styles.authForm}>
                        <button
                            onClick={() => onNavigate("welcome")}
                            style={styles.backLink}
                        >
                            ← Back to Home
                        </button>

                        <h2 style={styles.authTitle}>Sign In</h2>
                        <p style={styles.authSubtitle}>
                            Enter your credentials to continue
                        </p>

                        <div style={styles.formGroup}>
                            <label style={styles.label}>Username</label>
                            <input
                                type="text"
                                value={username}
                                onChange={(e) => setUsername(e.target.value)}
                                style={styles.input}
                                placeholder="Enter your username"
                                required
                            />
                        </div>

                        <div style={styles.formGroup}>
                            <label style={styles.label}>Password</label>
                            <input
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                style={styles.input}
                                placeholder="Enter your password"
                                required
                            />
                        </div>

                        {error && (
                            <div style={styles.errorMsg}>{error}</div>
                        )}

                        <button
                            onClick={handleLogin}
                            style={styles.submitBtn}
                            disabled={loading}
                        >
                            {loading ? "Signing in..." : "Sign In"}
                        </button>

                        <div style={styles.divider}>
                            <span style={styles.dividerText}>
                                Don't have an account?
                            </span>
                        </div>

                        <button
                            onClick={() => onNavigate("register")}
                            style={styles.switchBtn}
                        >
                            Create Account
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
