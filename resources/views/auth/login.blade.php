@extends('layouts.auth')
@section('title', 'Inicio de sesión')
@section('content')

    <h3 class="card-title text-left mb-3">Login</h3>

    @if (session('status'))
        <div class="alert alert-success text-center mb-4">
            {{ session('status') }}
        </div>
    @endif

    <form method="POST" action="{{ route('login') }}">
        @csrf

        <div class="form-group">
            <label for="login">Username or email *</label>
            <input id="login" name="login" type="text" class="form-control p_input" value="{{ old('login') }}"
                required autofocus autocomplete="username">
            @error('login')
                <small class="text-danger">{{ $message }}</small>
            @enderror
        </div>

        <div class="form-group">
            <label for="password">Password *</label>
            <input id="password" name="password" type="password" class="form-control p_input" required
                autocomplete="current-password">
            @error('password')
                <small class="text-danger">{{ $message }}</small>
            @enderror
        </div>

        <div class="form-group d-flex align-items-center justify-content-between">
            <div class="form-check">
                <label class="form-check-label" for="remember">
                    <input type="checkbox" class="form-check-input" name="remember" id="remember"
                        {{ old('remember') ? 'checked' : '' }}>
                    Remember me
                </label>
            </div>
            @if (Route::has('password.request'))
                <a href="{{ route('password.request') }}" class="forgot-pass">Forgot password?</a>
            @endif
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-primary btn-block enter-btn">Login</button>
        </div>

        <p class="sign-up text-center">
            Don't have an account?
            <a href="{{ route('register') }}">Sign Up</a>
        </p>
    </form>

@endsection
